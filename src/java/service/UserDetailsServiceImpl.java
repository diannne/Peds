/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package service;

import dao.UserDAO;
import dao.UserDAOImpl;
import java.util.ArrayList;
import java.util.List;
import model.UserRoles;
import model.Users;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author Diana
 */

public class UserDetailsServiceImpl implements UserDetailsService {

    @Autowired
    private UserDAO userDAO;
    
    @Override
    @Transactional(readOnly=true)
    public UserDetails loadUserByUsername(String login) 
            throws UsernameNotFoundException {
        userDAO = new UserDAOImpl();
        Users user = userDAO.getUser(login);
        
        if (user == null) {
            throw new UsernameNotFoundException("User " + login + " not found in database");
        } else {
            return new org.springframework.security.core.userdetails.User(
                    user.getUsername(), 
                    user.getPassword(), 
                    user.getEnabled() == 1, 
                    true, 
                    true, 
                    true, 
                    getGrantedRoles(user));
        }
    }
    
    //METHOD TO GET LIST OF GRANTED ROLES FOR A USER
    private List<GrantedAuthority> getGrantedRoles(Users usr){
        List<GrantedAuthority> roles = new ArrayList<>();
        
        for ( Object role : usr.getUserRoleses() ){
            SimpleGrantedAuthority sga = new SimpleGrantedAuthority(((UserRoles)role).getRole());
            roles.add(sga);
        }
        System.out.println("roles for user " + usr.getUsername() + " are " + roles);
        return roles;
    }

}
