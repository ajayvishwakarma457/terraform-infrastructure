
resource "aws_route53_zone" "this" {
  count = var.create_zone ? 1 : 0
  name  = var.zone_name
  tags  = var.tags
}

locals {
  hosted_zone_id = var.create_zone ? aws_route53_zone.this[0].zone_id : var.zone_id
}

resource "aws_route53_record" "this" {
  for_each = {
    # for r in var.records : "${r.name}-${r.type}" => r
    for idx, r in var.records : "${idx}-${r.name}-${r.type}" => r
  }

  zone_id = local.hosted_zone_id
  name    = each.value.name == "@" ? var.zone_name : each.value.name
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.records

  set_identifier = lookup(each.value, "set_identifier", null)
  health_check_id = lookup(each.value, "health_check_id", null)

  dynamic "weighted_routing_policy" {
    for_each = lookup(each.value, "weight", null) != null ? [1] : []
    content {
      weight = each.value.weight
    }
  }

  dynamic "latency_routing_policy" {
    for_each = lookup(each.value, "latency_region", null) != null ? [1] : []
    content {
      region = each.value.latency_region
    }
  }


  dynamic "geolocation_routing_policy" {
    for_each = lookup(each.value, "geo_location", null) != null ? [1] : []
    content {
      country     = lookup(each.value.geo_location, "country", null)
      continent   = lookup(each.value.geo_location, "continent", null)
      subdivision = lookup(each.value.geo_location, "subdivision", null)
    }
  }

  
  dynamic "failover_routing_policy" {
    for_each = lookup(each.value, "failover_type", null) != null ? [1] : []
    content {
      type = each.value.failover_type
    }
  }

}
