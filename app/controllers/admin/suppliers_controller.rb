module Admin
  class SuppliersController < BaseController             # [ЗГЕНЕРОВАНО] rails g controller Admin::Suppliers
    # ---- власний код: керування постачальниками ----
    def index
      @suppliers = Supplier.order(:id)
      @supplier  = Supplier.new
    end

    def create
      @supplier = Supplier.new(supplier_params)
      if @supplier.save
        redirect_to admin_suppliers_path, notice: "Постачальника додано", status: :see_other
      else
        @suppliers = Supplier.order(:id)
        render :index, status: :unprocessable_entity
      end
    end

    def edit
      @supplier = Supplier.find(params[:id])
    end

    def update
      @supplier = Supplier.find(params[:id])
      if @supplier.update(supplier_params)
        redirect_to admin_suppliers_path, notice: "Постачальника оновлено", status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      Supplier.find(params[:id]).destroy
      redirect_to admin_suppliers_path, notice: "Постачальника видалено", status: :see_other
    end

    private

    def supplier_params
      params.require(:supplier).permit(:name, :contact)
    end
  end
end
