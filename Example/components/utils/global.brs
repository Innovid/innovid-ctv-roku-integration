function _Globals(storageName_ = "_Innovid") as Object
  instance_ = m.Lookup("_.Globals")

  if instance_ = invalid then
    if not(m.global.hasField(storageName_)) then
      m.global.addField(storageName_, "node", false)
      m.global.setField(storageName_, CreateObject("roSGNode", "ContentNode"))
    end if

    instance_ = {
      _ : m.global[storageName_],

      get : function(key_ as String, default_ = invalid) as Dynamic
        if m._.hasField("__" + key_) then
          return m._["__" + key_].value
        else
          return default_
        end if
      end function,

      set : function(key_ as String, value_) as Void
        if not(m._.hasField("__" + key_)) then
          m._.addField("__" + key_, "assocarray", false)
        end if

        m._.setField("__" + key_, { value : value_ })
      end function,

      has : function(key_ as String) as Boolean
        return m._.hasField("__" + key_)
      end function
    }

    m.AddReplace("_.Globals", instance_)
  end if

  return instance_
end function
