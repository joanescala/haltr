class PaymentsController < ApplicationController

  unloadable
  menu_item :haltr

  helper :sort
  include SortHelper

  before_filter :find_project, :except => [:destroy,:edit,:update]
  before_filter :find_payment, :only   => [:destroy,:edit,:update]
  before_filter :authorize

  include CompanyFilter
  before_filter :check_for_company

  def index
    sort_init 'payments.date', 'desc'
    sort_update %w(payments.date amount_in_cents invoices.number)

    c = ARCondition.new(["project_id = ?", @project])

    unless params[:name].blank?
      name = "%#{params[:name].strip.downcase}%"
      c << ["LOWER(method) LIKE ? OR LOWER(reference) LIKE ?", name, name]
    end

    @payment_count = Payment.count(:conditions => c.conditions, :include => :invoice)
    @payment_pages = Paginator.new self, @payment_count,
		per_page_option,
		params['page']
    @payments = Payment.find :all, :order => sort_clause,
       :conditions => c.conditions,
       :include => :invoice,
       :limit  => @payment_pages.items_per_page,
       :offset => @payment_pages.current.offset

    render :action => "index", :layout => false if request.xhr?

  end


  def new
    if params[:invoice_id]
      invoice = Invoice.find params[:invoice_id]
      @payment = Payment.new(:invoice_id => invoice.id, :amount => invoice.unpaid)
    else
      @payment = Payment.new
    end
  end

  def edit
  end

  def create
    @payment = Payment.new(params[:payment].merge({:project=>@project}))
    if @payment.save
      flash[:notice] = 'Payment was successfully created.'
      if @payment.invoice
        redirect_to :controller => 'invoices', :action => 'showit', :id => @payment.invoice
      else
        redirect_to :action => 'index', :id => @project
      end
    else
      render :action => "new"
    end
  end

  def update
    if @payment.update_attributes(params[:payment])
      flash[:notice] = 'Payment was successfully updated.'
      redirect_to :action => 'index', :id => @project
    else
      render :action => "edit"
    end
  end

  def destroy
    @payment.destroy
    redirect_to :action => 'index', :id => @project
  end

  private

  def find_payment
    @payment = Payment.find(params[:id])
    @project = @payment.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end