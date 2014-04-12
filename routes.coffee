init = (app) ->
  require('./routes/stockapi').init app
  require('./routes/test').init app

module.exports = init: init
