class Admin::GroupsController < Admin::ApplicationController
  def index
    @groups = initialize_grid(Group,
      :per_page => Setting.page_size.to_i,
      :order => "id",
      :include => [:user_profiles])
  end

  def new
    @group = Group.new
    render :action => :edit
  end

  def edit
    @group = Group.find params[:id]
  end

  def create
    @group = Group.new params[:group]
    if @group.save
      success_notice "部门创建成功!"
      redirect_to admin_groups_path
    else
      render :action => :edit
    end
  end

  def update
    @group = Group.find params[:id]
    if @group.update_attributes(params[:group])
      success_notice "部门修改成功!"
      redirect_to admin_groups_path
    else
      render :action => :edit
    end
  end

  def destroy
    @group = Group.find params[:id]
    if @group.destroy
      success_notice "部门删除成功!"
    else
      error_notice "部门删除失败!"
    end
    redirect_to admin_groups_path
  end

end