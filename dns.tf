resource "google_dns_managed_zone" "dns" {
  name     = "ncode"
  dns_name = "nxcode.hu."
}

#resource "google_dns_record_set" "dns" {
#  name = "trader.${google_dns_managed_zone.dns.dns_name}"
#  type = "A"
#  ttl  = 300
#
#  managed_zone = google_dns_managed_zone.dns.name
#}