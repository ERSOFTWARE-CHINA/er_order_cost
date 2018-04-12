defmodule RestfulApiWeb.TranslateMsg do
    require RestfulApiWeb.Gettext
  
    def translate_msg(s) do
      Gettext.gettext(RestfulApiWeb.Gettext, s)
    end
  
    def sigil_t(string, []), do: Gettext.gettext(RestfulApiWeb.Gettext, string)
  end