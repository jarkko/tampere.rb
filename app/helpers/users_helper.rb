module UsersHelper
  ROLE_MAP = {'admin' => 'yll&auml;pit&auml;j&auml;', 'member' => 'j&auml;sen'}
  def fin_role(role)
    ROLE_MAP[role]
  end
end
