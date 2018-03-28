defmodule RestfulApi.PurchaseService.OrderDetail do
	use Ecto.Schema
	import Ecto.Changeset
	alias RestfulApi.OrderService.Order
	alias RestfulApi.ProductionService.Production


	schema "order_details" do
		field :price, :float			 # 配件单价
		field :amount, :integer    		 # 数量
		field :total_price, :float 		 # 总价
		belongs_to :order, Order, on_replace: :nilify
		belongs_to :production, Production, on_replace: :delete
		timestamps()
	end

	@doc false
	def changeset(order_detail, attrs) do
		order_detail
		|> cast(attrs, [:price, :amount, :total_price])
		|> validate_required([:price, :amount])
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
