defmodule RestfulApi.PurchaseService.PurchaseDetail do
	use Ecto.Schema
	import Ecto.Changeset
	alias RestfulApi.SparepartService.Sparepart


	schema "purchase_details" do
		field :price, :float			 # 配件单价
		field :amount, :integer    		 # 数量
		field :total_price, :float 		 # 总价
		has_one :sparepart, Sparepart, on_replace: :nilify
		timestamps()
	end

	@doc false
	def changeset(purchase_detail, attrs) do
		purchase_detail
		|> cast(attrs, [:price, :amount, :total_price])
		|> validate_required([:price, :amount, :total_price])
		|> set_totalprice()
	end

	defp set_totalprice(changeset) do
		case changeset do
			%Ecto.Changeset{valid?: true, changes: %{amount: amount, price: price}} ->
				put_change(changeset, :total_price, amount * price)
			_ ->
				changeset
		end
	end
end