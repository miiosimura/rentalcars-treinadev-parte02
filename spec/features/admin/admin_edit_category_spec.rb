require 'rails_helper'

feature 'Admin edit category' do
  scenario 'successfully' do
    admin = create(:user, role: :admin)
    create(:category, name: 'A')
    
    login_as admin
    visit root_path
    click_on 'Categorias'
    click_on 'A'
    click_on 'Editar'
    fill_in 'Nome', with: 'C'
    fill_in 'Diária padrão', with: 55.40
    fill_in 'Seguro padrão contra terceiros', with: 32.22
    fill_in 'Seguro padrão do carro', with: 12
    click_on 'Enviar'

    expect(page).to have_content('Categoria atualizada com sucesso!')
    expect(page).to_not have_content('Nome: A')
    expect(page).to have_content('Nome: C')
    expect(page).to have_content('Diária padrão: R$ 55,40')
    expect(page).to have_content('Seguro padrão contra terceiros: R$ 32,22')
    expect(page).to have_content('Seguro padrão do carro: R$ 12,00')
  end
end