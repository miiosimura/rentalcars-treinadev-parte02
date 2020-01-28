class IndividualClientMailer < ApplicationMailer
  def confirm(client_id)
    @client = IndividualClient.find(client_id)
    mail(to: @client.email, subject: "#{@client.name}, bem vindo ao Rental Cars!")
  end
end