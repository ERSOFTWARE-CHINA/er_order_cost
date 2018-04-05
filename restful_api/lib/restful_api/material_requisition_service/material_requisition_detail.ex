defmodule RestfulApi.MaterialRequisitionService.MaterialRequisitionDetail do
	use Ecto.Schema
	import Ecto.Changeset
	alias RestfulApi.SparepartService.Sparepart
	alias RestfulApi.MaterialRequisitionService.MaterialRequisition


	schema "material_requisitions_details" do
		field :price,  		:float
		field :amount, 		:integer
		field :total_price, :float
		belongs_to :sparepart, 			  Sparepart, 		   on_replace: :nilify
		belongs_to :material_requisition, MaterialRequisition, on_replace: :delete
		timestamps()
	end

	@doc false
	def changeset(purchase_detail, attrs) do
		purchase_detail
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
