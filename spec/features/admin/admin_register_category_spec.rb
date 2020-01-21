require 'rails_helper'

feature 'Admin register category' do
  scenario 'succesfully' do
    admin = create(:user, role: :admin)

    login_as admin, scope: :user
    visit root_path
    click_on 'Categorias'
    click_on 'Criar Nova Categoria'
    fill_in 'Nome', with: 'A'
    fill_in 'Diária padrão', with: 80
    fill_in 'Seguro padrão contra terceiros', with: 40
    fill_in 'Seguro padrão do carro', with: 20
    click_on 'Enviar'

    expect(page).to have_content('Categoria cadastrada com sucesso!')
    expect(page).to have_content('Nome: A')
    expect(page).to have_content('Diária padrão: R$ 80,00')
    expect(page).to have_content('Seguro padrão contra terceiros: R$ 40,00')
    expect(page).to have_content('Seguro padrão do carro: R$ 20,00')
  end
end