/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import java.util.ArrayList;
import java.util.List;
import model.HibernateUtil;
import model.Users;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 *
 * @author Diana
 */
@Repository
public class UserDAOImpl implements UserDAO {

    @Autowired
    private final SessionFactory sessionFactory;

    public UserDAOImpl() {
        sessionFactory = HibernateUtil.getSessionFactory();
    }

    @Override
    public Users getUser(String login) {
        
        Session session = sessionFactory.openSession();
        Query query = session.createQuery("from Users u where u.username = :login");
        query.setParameter("login", login);
        
        if (query.list().size() > 0) {
            return (Users)query.list().get(0);
        } else {
            return null;
        }
    }
}
