module UsersHelper
  ROLE_MAP = {'admin' => 'ylläpitäjä', 'member' => 'jäsen'}
  def fin_role(role)
    ROLE_MAP[role]
  end
end
