# Terragrunt EKS Infrastructure

Repo này dùng Terragrunt để quản lý các cấu hình Terraform triển khai EKS trên AWS (theo env `dev`).

## Cấu trúc thư mục

- `infra/`
  - `terragrunt.hcl`: cấu hình root, define `locals.common_tags` và generate provider AWS (chỉ set `region`, credential lấy từ AWS profile/env/IAM role).
  - `secrets.hcl`: **optional, chỉ lưu local, đã được .gitignore** (không còn dùng để truyền access key/secret key).
  - `envs/dev/`
    - `dev.hcl`: locals cho environment `dev` (`environment`, `common_tags`).
    - `backend/terragrunt.hcl`: stack tạo S3 bucket & DynamoDB table để làm Terraform remote state/lock.
    - `vpc/terragrunt.hcl`: stack tạo VPC và subnet cho EKS.
    - `iam-eks/terragrunt.hcl`: IAM role & policy attachment cho EKS control plane.
    - `iam-node/terragrunt.hcl`: IAM role & policy attachment cho worker node.
    - `eks/terragrunt.hcl`: EKS cluster, sử dụng output từ `vpc` và `iam-eks` (có `mock_outputs` để plan được khi chưa apply).
    - `nodegroup/terragrunt.hcl`: EKS node group, dùng output từ `vpc`, `eks`, `iam-node` (cũng có `mock_outputs` cho plan).
  - `modules/`
    - `backend/`: module Terraform tạo `aws_s3_bucket` và `aws_dynamodb_table`.
    - `vpc/`: module Terraform tạo `aws_vpc` và 2 public + 2 private subnet.
    - `iam-eks/`: module Terraform tạo IAM role cho EKS control plane và attach policy AWS managed.
    - `iam-node/`: module Terraform tạo IAM role cho node group và attach policy AWS managed.
    - `eks/`: module Terraform tạo `aws_eks_cluster`.
    - `nodegroup/`: module Terraform tạo `aws_eks_node_group`.

## Repo này tạo những gì?

Với env `dev`, các stack Terragrunt tương ứng sẽ tạo (khi có AWS credentials thật và bỏ mock/dummy nếu cần):

- **backend**
  - 1 S3 bucket dùng làm Terraform state bucket.
  - 1 DynamoDB table dùng làm state lock.

- **vpc**
  - 1 VPC CIDR `10.0.0.0/16`.
  - 2 public subnet (`10.0.1.0/24`, `10.0.2.0/24`) ở `ap-southeast-1a/b`.
  - 2 private subnet (`10.0.11.0/24`, `10.0.12.0/24`) ở `ap-southeast-1a/b`.

- **iam-eks**
  - 1 IAM role `eks-cluster-dev` với trust policy cho `eks.amazonaws.com`.
  - Attach policy:
    - `arn:aws:iam::aws:policy/AmazonEKSClusterPolicy`
    - `arn:aws:iam::aws:policy/AmazonEKSVPCResourceController`

- **iam-node**
  - 1 IAM role `eks-node-dev` với trust policy cho `ec2.amazonaws.com`.
  - Attach policy:
    - `arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy`
    - `arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy`
    - `arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly`

- **eks**
  - 1 EKS cluster tên `eks-dev` (version `1.30`), dùng subnets private và role từ `iam-eks`.

- **nodegroup**
  - 1 managed node group tên `eks-nodegroup-dev`:
    - `instance_types = ["t3.medium"]`
    - `desired = 2`, `min = 1`, `max = 3`
    - `disk_size = 20`

Tất cả resource đều được gán tag chung: `Project=EKS`, `ManagedBy=Terragrunt`, `Environment=dev`.

## Chạy Terragrunt

### Chuẩn bị

1. Cấu hình AWS credentials bên ngoài Terraform/Terragrunt (một trong các cách):
  - `aws configure` với profile `default` hoặc đặt `AWS_PROFILE`.
  - Export env vars: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN` (nếu cần).
  - Hoặc dùng IAM role gán cho EC2/EKS runner.

2. Đảm bảo đã cài:
   - Terraform
   - Terragrunt (CLI mới, dùng `terragrunt run --all`)

### Plan/apply từng stack

Ví dụ với env `dev`:

```bash
cd infra/envs/dev

# Plan toàn bộ (trừ backend nếu chưa muốn đụng S3 thật)
terragrunt run --all plan --queue-exclude-dir=. --queue-exclude-dir=backend

# Apply từng phần
cd vpc        && terragrunt apply
cd ../iam-eks && terragrunt apply
cd ../iam-node && terragrunt apply
cd ../eks        && terragrunt apply
cd ../nodegroup  && terragrunt apply

# Khi sẵn sàng tạo S3+DynamoDB cho backend
cd ../backend && terragrunt apply
```

> Lưu ý: Hiện một số unit (`eks`, `nodegroup`) đang dùng `mock_outputs` và provider dummy để có thể `plan` mà không cần AWS credentials. Khi triển khai thật, có thể bỏ mock/dummy và dùng credentials chuẩn (AWS CLI profile, env vars, v.v.).
