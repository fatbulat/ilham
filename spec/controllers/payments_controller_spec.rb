require 'rails_helper'

describe PaymentsController do
  describe '#create' do
    let(:fiction) { FactoryGirl.create :fiction, price: 1000 }
    let(:user)    { FactoryGirl.create :user }
    let(:params)  { { payment: { fiction_id: fiction.id } } }

    context 'when user do not signed in' do
      it 'should change payments count' do
        expect{ post :create, params }.not_to change(Payment, :count)
      end
    end

    context 'when user signed in' do
      before do
        sign_in user
      end

      context 'and purchase do not exist' do

        it 'should change user purchases count' do
          expect{ post :create, params }.to change(user.purchases, :count).by(1)
        end

        it 'should change payments count' do
          expect{ post :create, params }.to change(Payment, :count).by(1)
        end
      end

      context 'and purchase exist' do
        let!(:purchase) { user.purchases.create(fiction: fiction) }

        it 'should not change purchases count' do
          expect{ post :create, params }.not_to change(Purchase, :count)
        end

        context 'with payed status' do
          before { purchase.pay! }

          it 'should not change payments count' do
            expect{ post :create, params }.not_to change(Payment, :count)
          end
        end

        context 'without payed status' do
          it 'should change payments count' do
            expect{ post :create, params }.to change(Payment, :count)
          end
      end

      context 'payment sum' do
        before { post :create, params }
        it { expect(Payment.last.sum).to eq(fiction.price) }
      end
    end
  end

  describe '#confirm' do
    describe 'status is pay' do
      let(:user)    { FactoryGirl.create :user }
      let(:fiction) { FactoryGirl.create :fiction }
      let(:payment) { FactoryGirl.create :payment, fiction: fiction, user: user }
      let(:params)  { { method: 'pay', params: { account: payment.id } } }
      let(:json)    { { result: { message: 'Success' } }.to_json }

      context 'user buys the fiction' do
        before do
          get :confirm, params
        end

        it { expect(response.body).to eq(json) }
        it { expect(user.bought?(fiction)).to eql(true) }
      end

      context 'user gives the fiction' do
        let!(:presentee) { FactoryGirl.create :user }
        let!(:gift)      { FactoryGirl.create :gift, presentee: presentee,
                           present: fiction, payment: payment }

        before do
          get :confirm, params
          gift.reload
        end

        it { expect(response.body).to eq(json) }
        it { expect(user.bought?(fiction)).to eq(false) }
        it { expect(gift.paid).to eq(true) }
      end
    end
  end
end
