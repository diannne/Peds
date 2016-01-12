/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

import org.hibernate.FlushMode;
import org.hibernate.Session;
import org.hibernate.cfg.AnnotationConfiguration;
import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.context.internal.ManagedSessionContext;
import org.hibernate.search.FullTextSession;
import org.hibernate.search.Search;

/**
 * Hibernate Utility class with a convenient method to get Session Factory
 * object.
 *
 * @author Diana
 */
public class HibernateUtil {

    private static SessionFactory sessionFactory;
    private static StandardServiceRegistry serviceRegistry;
    private static Configuration configuration;
//    static {
//        try {
//            // Create the SessionFactory from standard (hibernate.cfg.xml) 
//            // config file.
//            sessionFactory = new AnnotationConfiguration().configure().buildSessionFactory();
//        } catch (Throwable ex) {
//            // Log the exception. 
//            System.err.println("Initial SessionFactory creation failed." + ex);
//            throw new ExceptionInInitializerError(ex);
//        }
//    }

    public static SessionFactory getSessionFactory()  {
        if( sessionFactory == null ) {
            configuration = new Configuration().configure();
            serviceRegistry = new StandardServiceRegistryBuilder().applySettings(configuration.getProperties()).build();
            sessionFactory = configuration.buildSessionFactory(serviceRegistry);
            //createIndexer(sessionFactory);
           
            
        }
        return sessionFactory;
    }

    private static void createIndexer(SessionFactory sessionFactory) throws InterruptedException {
         Session session = sessionFactory.openSession();
            session.setFlushMode(FlushMode.MANUAL);
            ManagedSessionContext.bind(session);
            FullTextSession fullTextSession = Search.getFullTextSession(session);  
            fullTextSession.createIndexer().startAndWait();
            ManagedSessionContext.unbind(HibernateUtil.getSessionFactory());
            session.flush();
    }
}
