rm -rf *.tgz
helm lint --strict ibm-txseries 
helm package ibm-txseries
bx pr login
bx pr delete-helm-chart --name ibm-txseries
bx pr load-helm-chart --archive ibm-txseries-*
