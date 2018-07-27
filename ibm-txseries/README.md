# TXSeries for Multiplatforms Helm Chart
  TXSeries for Multiplatforms (TXSeries) is a mixed-language application server for COBOL and C applications. TXSeries offers a reliable, scalable, and highly available platform to develop, deploy, and host, mission-critical applications. TXSeries delivers capabilities that enable deployment of applications on Container-as-a-service platforms using Docker technology for Cloud environments.

## Requirements

Kubernetes 1.9 or greater, with beta APIs enabled

A persistent volume is required, if you plan to use recovery of TXSeries Region and SFS server resources. When recoverable resources are used then enable persistency which will retian and recover the data after restart of TXSeries region or SFS server.  

In particular, if you use files, transient data queues, and temporary storage queues that are read-only, define them as nonrecoverable.

## Resources Required

This chart uses the following resources by default:

0.5 CPU core
0.5 Gi memory
1 Gi persistent volume.

## Accessing TXSeries

From a client application , use tcp://*external ip*:*nodeport* to access the TXSeries region.

## Configuration

### Parameters

The Helm chart has the following values that can be overriden using the --set parameter. For example:

*    `helm repo add ibm-charts https://raw.githubusercontent.com/IBM/charts/master/repo/stable/`
*    `helm install --name TXSeries2 --set resources.constraints.enabled=true --set autoscaling.enabled=true --set autoscaling.minReplicas=2 ibm-charts/ibm-txeries --debug`

##### Common Parameters

| Qualifier | Parameter  | Definition | Allowed Value |
|---|---|---|---|
| image     | pullPolicy | Image Pull Policy | Always, Never, or IfNotPresent. Defaults to Always if :latest tag is specified, or IfNotPresent otherwise  |
|           | repository | Name of image, including repository prefix (if required). | See Extended description of Docker tags. |
|           | tag        | Docker image tag. | See Docker tag description |
| TXSeries Administration Console Service   | name       | The name of the port service.  | |
|           | type       | Specify type of service. | Valid options are ClusterIP and NodePort. See Publishing services - service types. |
|           | port       | The port that this container exposes for TXSeries Administration Console.  |   |
|           | targetPort | Port that will be exposed externally by the pod. | |
| TXSeries Listener Service  | name       | The name of the port service.  | |
|           | type       | Specify type of service. | Valid options are  ClusterIP and NodePort. See Publishing services - service types. |
|           | port       | The port that this container exposes for TXSeries listener connectivity.  |   |
|           | targetPort | Port that will be exposed externally by the pod. | |
| persistence | name                   | Descriptive name that will be used prefix the generated persistence volume claim. A volume is only bound if either tranlog.persistLogs or logs.persistLogs is set to true. | |
|             | enablePersistency | When true, the TXSeries region/SFS Server resources will be persisted to the volume bound according to the persistence parameters. | true(default) or false|
|             | useDynamicProvisioning | If true, the persistent volume claim will use the storageClassName to bind the volume. If storageClassName is not set it will use the default storageClass setup by kube Administrator.  If false, the selector will be used for the binding process. | true (default) or false |
|             | storageClassName       | Specifies a StorageClass pre-created by the Kubernetes sysadmin. When set to "", then the PVC is bound to the default storageClass setup by kube Administrator. | |
|             | selector.label         | When matching a PV, the label is used to find a match on the key. See Kubernetes - https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ | |
|             | selector.value         | When matching a PV, the value is used to find a match on the values. See Kubernetes - https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ | |
|             | size                   | Size of the volume to hold all the persisted data. | Size in Gi (default is 1Gi) |
| replicaCount |     |  Describes the number of desired replica pods running at the same time. | Default is 1.  See [Replica Sets](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset) |
| autoscaling | enabled                        | Specifies whether a horizontal pod autoscaler (HPA) is deployed.  Note that enabling this field disables the `replicaCount` field. | false (default) or true |
|             | minReplicas                    | Lower limit for the number of pods that can be set by the autoscaler.   |  Positive integer (default to 1)  |
|             | maxReplicas                    | Upper limit for the number of pods that can be set by the autoscaler.  Cannot be lower than `minReplicas`.   |  Positive integer (default to 10)  |
|             | targetCPUUtilizationPercentage | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods.  |  Positive integer between 1 and 100 (default to 50)  |
| resources | constraints.enabled | Specifies whether the resource constraints specified in this Helm chart are enabled.   | false (default) or true  |
|           | limits.cpu          | Describes the maximum amount of CPU allowed. | Default is 500m. See Kubernetes - [meaning of CPU](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#meaning-of-cpu)  |
|           | limits.memory       | Describes the maximum amount of memory allowed. | Default is 512Mi. See Kubernetes - [meaning of Memory](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#meaning-of-memory) |
|           | requests.cpu        | Describes the minimum amount of CPU required - if not specified will default to limit (if specified) or otherwise implementation-defined value. | Default is 500m. See Kubernetes - [meaning of CPU](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#meaning-of-cpu) |
|           | requests.memory     | Describes the minimum amount of memory required. If not specified, the memory amount will default to the limit (if specified) or the implementation-defined value. | Default is 512Mi. See Kubernetes - [meaning of Memory](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#meaning-of-memory) |

##### Configuring TXSeries within IBM Cloud Private

###### Recovery of TXSeries Region/SFS Server resources
If the server fails and restarts, then to persist the TXSeries Region/SFS Server resources (preserve them through server restarts) you must set persistence.enablePercistency to true and configure persistence in the helm chart. 


###### Persisting logs

Create a persistent volume (PV) in a shared storage, NFS for example, with the following specification:
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: <persistent volume name>
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  storageClassName: <optional - must match PVC>
  nfs:
    server: <NFS Server IP>
    path: <NFS PATH>
```
Note: For NFS PATH you need to create your directory manually before deploying the persistent volume.

You can create a PV using the above template by executing:

kubectl create -f <yaml-file>

You can also create a PV from IBM Cloud Private UI by following these steps:

    From the Dashboard panel, click Create resource.
    Copy and paste the PV template.
    Click Create.

###### More information
For TXSeries product related information visit the [TXSeries documentation](https://www.ibm.com/support/knowledgecenter/en/SSAL2T_9.1.0/com.ibm.cics.tx.doc/ic-homepage.html) . 

