import { sleep } from 'k6'
import http from 'k6/http'

// See https://grafana.com/docs/k6/latest/using-k6/k6-options/reference/
export const options = {
  scenarios: {
    open_model: {
      executor: 'constant-arrival-rate',
      rate: 10,
      timeUnit: '1s',
      duration: '60s',
      preAllocatedVUs: 500,
    },
  },
}

export default function main() {
  let response = http.get('https://wlvypkf3.global.ssl.fastly.net/busy')
  sleep(10)
}
