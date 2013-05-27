if Redmine::VERSION::MAJOR == 1

  ActionController::Routing::Routes.draw do |map|
    map.connect '/tasks/report/:id/:months_ago', :controller => 'tasks', :action => 'report'
    map.resources :invoices, :has_many => :events, :collection => { :by_taxcode_and_num => :get }
    map.resources :events
    map.connect '/invoices/logo/:id/:filename', :controller => 'invoices', :action => 'logo', :id => /\d+/, :filename => /.*/
    map.connect '/invoices/legal/:id.:format', :controller => 'invoices', :action => 'legal'
    map.connect '/invoice/download/:id/:invoice_id', :controller => 'invoices', :action => 'download', :id => /.*/, :invoice_id => /\d+/
    map.connect '/invoice/:id/:invoice_id', :controller => 'invoices', :action => 'view', :id => /.*/, :invoice_id => /\d+/
    map.connect '/statistics', :controller => 'stastics', :action => 'index'
    map.connect '/invoices/:action/:id', :controller => 'invoices'
    map.connect '/received/:action/:id', :controller => 'received'
    map.connect '/templates/:action/:id', :controller => 'invoice_templates'
    map.connect '/clients/:action/:id', :controller => 'clients'
    map.connect '/companies/:action/:id', :controller => 'companies'
    map.connect '/payments/:action/:id', :controller => 'payments'
    map.connect '/tasks/:action/:id', :controller => 'tasks'
    map.connect '/people/:action/:id', :controller => 'people'
  end

else
  # NOTE: all xml and json requests will use Redmine's API auth
  #        %w(xml json).include? params[:format]
  match '/tasks/report/:id/:months_ago' => 'tasks#report'
  resources :invoices, :has_many => :events, :collection => { :by_taxcode_and_num => :get }
  resources :events
  match '/invoices/logo/:id/:filename' => 'invoices#logo', :id => /\d+/, :filename => /.*/
  match '/invoice/download/:id/:invoice_id' => 'invoices#download', :id => /.*/, :invoice_id => /\d+/
  match '/invoice/:id/:invoice_id' => 'invoices#view', :id => /.*/, :invoice_id => /\d+/
  match '/statistics' => 'stastics#index'
  match '/invoices/:action/:id' => 'invoices'
  match '/received/:action/:id' => 'received'
  match '/templates/:action/:id' => 'invoice_templates'
  match '/clients/:action/:id' => 'clients'
  match '/companies/:action/:id' => 'companies'
  match '/payments/:action/:id' => 'payments'
  match '/tasks/:action/:id' => 'tasks'
  match '/people/:action/:id' => 'people'
end
