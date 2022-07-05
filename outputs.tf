output "cp4na_endpoints" {
  depends_on = [
    data.external.get_cp4na_endpoints,
  ]
  value = length(data.external.get_cp4na_endpoints) > 0 ? data.external.get_cp4na_endpoints.result.endpoint : ""
}