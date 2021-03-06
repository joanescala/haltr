class ClientOffice < ActiveRecord::Base

  unloadable

  belongs_to :client
  has_many :invoices, dependent: :nullify
  validates_presence_of :name

  CLIENT_FIELDS = %w( address address2 city province postalcode country email name )

  CLIENT_FIELDS.each do |attr|
    define_method(attr) do
      read_attribute(attr).blank? ? client.send(attr) : read_attribute(attr)
    end
  end

  def to_s
    name.blank? ? client.to_s : name
  end

  def full_address
    addr = address
    addr += "\n#{address2}" if address2.present?
    addr
  end

  def country_alpha3
    country
  end

end
