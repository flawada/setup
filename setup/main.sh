cd /tmp/blueprint/blueprints


blueprints=()
i=0

for blueprint in */; do
  ((i++))
  blueprints+=("$blueprint")
  echo "$i) ${blueprint%/}"
done