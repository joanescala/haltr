# Signs a PDF invoice and sends it by email

module Haltr
  class SendSignedPdfByMail < GenericSender

    attr_accessor :pdf

    def perform
      # create PDF
      self.pdf = Haltr::Pdf.generate(invoice)
      # sign PDF
      # TODO
      # send it by email
      HaltrMailer.send_invoice(invoice,pdf).deliver
    end

    def create_event(name)
      filename = "#{I18n.t(:label_invoice)}_#{invoice.number.gsub(/[^\w]/,'_')}.pdf" rescue "Invoice.pdf"
      EventWithFile.create!(:name         => name,
                            :invoice      => invoice,
                            :notes        => invoice.recipient_emails.join(', '),
                            :file         => pdf,
                            :filename     => filename,
                            :content_type => 'application/pdf')
    end

  end
end
