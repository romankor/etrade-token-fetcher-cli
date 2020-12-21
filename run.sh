#! /bin/bash
set -e

echo "Fetching Tokens"
tokens=$(ETradeAuth --consumerKey ${ETRADE_CONSUMER_KEY} --consumerSecret ${ETRADE_CONSUMER_SECRET} --webPassword ${ETRADE_PASSWORD} --webUsername ${ETRADE_USERNAME})
echo "$tokens"
oauth_token=$(jq ".oauth_token" -r <<< "$tokens")
oauth_token_secret=$(jq ".oauth_token_secret" -r <<< "$tokens")

kubectl --token=${KUBERNETES_TOKEN} create configmap etrade-tokens --from-literal=OAUTH_TOKEN=${oauth_token} --from-literal=OAUTH_TOKEN_SECRET=${oauth_token_secret} -o yaml --dry-run | kubectl --token=${KUBERNETES_TOKEN} apply -f -
