function _TypesUtil() as Object
  instance_ = m.Lookup("_.TypesUtil")

  if instance_ = invalid then
    instance_ = {
      isBoolean : function(value_ as Dynamic) as Boolean
        return GetInterface(value_, "ifBoolean") <> invalid
      end function,

      isArray : function(value_) as Boolean
        return value_ <> invalid and GetInterface(value_, "ifArray") <> invalid
      end function,

      isString : function(value_) as Boolean
        return value_ <> invalid and GetInterface(value_, "ifString") <> invalid
      end function,

      isObject : function(value_) as Boolean
        return value_ <> invalid and GetInterface(value_, "ifAssociativeArray") <> invalid
      end function,

      isNumeric : function(value_) as Boolean
        return value_ <> invalid and (GetInterface(value_, "ifInt") <> invalid or GetInterface(value_, "ifFloat") <> invalid)
      end function,

      isInteger : function(value_) as Boolean
        return value_ <> invalid and GetInterface(value_, "ifInt") <> invalid
      end function,

      isFloat : function(value_) as Boolean
        return value_ <> invalid and GetInterface(value_, "ifFloat") <> invalid
      end function

      isScalar : function(value_ as Dynamic) as Boolean
        return m.isNumeric( value_ ) or m.isBoolean( value_ ) or m.isString( value_ )
      end function,

      isFunction : function(value_ as Dynamic) as Boolean
        return value_ <> invalid and GetInterface(value_, "ifFunction") <> invalid
      end function,

      isEmpty : function(raw_ as Dynamic) as Boolean
        if raw_ = invalid then
          return true
        end if

        if m.isString( raw_ ) then
          return (raw_.Trim() = "")
        end if

        return false
      end function
    }

    m.AddReplace("_.TypesUtil", instance_)
  end if

  return instance_
end function
