require 'rails_helper'

describe 'Individual Client Mailer' do
  describe '#confirm' do
    it 'should send to the customer email' do
      customer = create(:individual_client, name: 'claudionor',
                        cpf: '318.421.176-43', email: 'cro@email.com')
      
      mail = IndividualClientMailer.confirm(customer.id)

      expect(mail.to).to include(customer.email)
    end

    it 'should send from the enterprise email' do
      customer = create(:individual_client, name: 'claudionor',
                        cpf: '318.421.176-43', email: 'cro@email.com')

      mail = IndividualClientMailer.confirm(customer.id)

      expect(mail.from).to include('rentalcars@email.com')
    end

    it 'should send with the correct title' do
      customer = create(:individual_client, name: 'claudionor',
                        cpf: '318.421.176-43', email: 'cro@email.com')

      mail = IndividualClientMailer.confirm(customer.id)

      expect(mail.subject).to eq("#{customer.name}, bem vindo ao Rental Cars!")
    end

    it 'should send the body' do
      customer = create(:individual_client, name: 'claudionor',
                        cpf: '318.421.176-43', email: 'cro@email.com')

      mail = IndividualClientMailer.confirm(customer.id)

      expect(mail.body).to include("Seu cadastro foi realizado com sucesso!")
    end
  end
end