# Format EKS :
1. aws_iam_role (clúter)
2. aws_iam_role_policy_attachment
3. aws_eks_cluster
4. aws_iam_role (node)
5. aws_iam_role_policy_attachment
6. aws_route_table
aws_route_table_private
aws_route_table_public
7. aws_route_table_association
aws_route_table_association_subnet_private_1a
aws_route_table_association_subnet_private_1b
aws_route_table_association_subnet_public_1a
aws_route_table_association_subnet_public_1b

aws eks update-kubeconfig --name demo --region ap-southeast-1 --profile chungndinh
