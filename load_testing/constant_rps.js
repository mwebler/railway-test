import { sleep } from 'k6'
import http from 'k6/http'

// See https://grafana.com/docs/k6/latest/using-k6/k6-options/reference/
export const options = {
  scenarios: {
    open_model: {
      executor: 'constant-arrival-rate',
      rate: 4,
      timeUnit: '1s',
      duration: '5m',
      preAllocatedVUs: 20,
    },
  },
}

export default function main() {
  let response = http.get('https://wlvypkf3.global.ssl.fastly.net/slow')
  sleep(2)
}
