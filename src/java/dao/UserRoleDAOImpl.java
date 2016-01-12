/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import model.UserRoles;
import org.hibernate.SessionFactory;

/**
 *
 * @author Diana
 */
public class UserRoleDAOImpl implements UserRoleDAO{

    private SessionFactory sessionFactory;
    
    @Override
    public UserRoles getRole(int id) {
        UserRoles role = (UserRoles) sessionFactory.getCurrentSession().load(UserRoles.class, id);
        return role;
    }
    
    
}
