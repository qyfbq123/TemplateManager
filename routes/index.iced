exports.index = (req, res)->
  res.render 'index'

exports.templates = (req, res)->
  res.render 'partials/templates'

exports.subTemplates = (req, res)->
  res.render 'partials/subTemplates'
