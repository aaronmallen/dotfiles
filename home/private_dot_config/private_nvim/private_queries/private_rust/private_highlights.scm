; extends

((visibility_modifier "pub" @keyword.visibility) (#set! priority 130))

((crate) @keyword.crate (#set! priority 130))

("dyn" @keyword.dyn (#set! priority 130))

("move" @keyword.move (#set! priority 130))

((attribute_item (attribute (identifier) @attribute.name)) (#set! priority 130))
