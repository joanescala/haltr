class AddReceiveInternalInvoicesToCompanies < ActiveRecord::Migration

  def up
    add_column :companies, :receive_internal_invoices, :boolean, default: true
  end

  def down
    remove_column :companies, :receive_internal_invoices
  end

end
