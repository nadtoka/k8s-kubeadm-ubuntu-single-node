# 05 - Metrics Server

## Summary

Deploy metrics-server to enable `kubectl top` and autoscaling metrics.

## Steps

```bash
sudo bash scripts/05-metrics-server.sh
```

## Notes

* The manifest is pulled from the pinned version `${METRICS_SERVER_VERSION}`.
* It can take a minute or two for metrics to show up.
