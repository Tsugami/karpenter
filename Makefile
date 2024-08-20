AWS_REGION=us-east-1
EKS_CLUSTER_NAME=karpenter-demo-eks-cluster
KUBECTL_ALIAS=karpenter-demo

apply:
	terraform apply

init:
	terraform init

apply-auto:
	terraform apply -auto-approve

console:
	terraform console

destroy:
	terraform destroy
update-kubeconfig:
	aws eks update-kubeconfig --region $(AWS_REGION) --name $(EKS_CLUSTER_NAME) --alias $(KUBECTL_ALIAS)

karpenter-logs:
	kubectl logs -n karpenter deployment/karpenter -f

fix-coredns:
	kubectl patch deployment coredns \
    -n kube-system \
    --type json \
    -p='[{"op": "remove", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type"}]' \
	&& kubectl rollout restart deployment coredns -n kube-system

karpenter-deploy-describe:
	kubectl describe deployment karpenter -n karpenter