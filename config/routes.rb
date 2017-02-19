Rails.application.routes.draw do
  post '/api/config_reports', to: 'report_import_controler#create'
end
