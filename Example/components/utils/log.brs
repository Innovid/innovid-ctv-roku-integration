function _Logger(category_ = "Log" as String) as Object
  return {
    _category : category_,

    i  : function(msg_ as String, params_ = invalid) as Void
      m._log( 1, msg_, params_ )
    end function,

    d : function(msg_ as String, params_ = invalid) as Void
      m._log( 2, msg_, params_ )
    end function,

    w  : function(msg_ as String, params_ = invalid) as Void
      m._log( 3, msg_, params_ )
    end function,

    e : function(msg_ as String, params_ = invalid) as Void
      m._log( 4, msg_, params_ )
    end function,

    f : function(msg_ as String, params_ = invalid) as Void
      m._log( 5, msg_, params_ )
    end function,

    _log  : function(level_ as Integer, msg_ as String, params_ = invalid) as Void
      ? ">>>>> ";m._category;" # ";msg_;

      if params_ = invalid then
        ? ""
      else
        ? " -- ";params_
      end if
    end function
  }
end function
