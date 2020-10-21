# Configure DNS

```bash
kubectl patch configmap/config-domain \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"knative.runitoncloud.com":""}}'
```
