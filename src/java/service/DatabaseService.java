/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package service;

import java.util.List;
import model.HibernateUtil;
import model.Users;
import org.hibernate.FlushMode;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.context.internal.ManagedSessionContext;
import org.hibernate.search.FullTextSession;
import org.hibernate.search.query.dsl.QueryBuilder;
//import org.hibernate.search.FullTextSession;
//import org.hibernate.search.query.dsl.QueryBuilder;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author Diana
 */
public class DatabaseService implements IDatabaseService {

    @Transactional
    @Override
    public void saveEntity(Object entity) {
        SessionFactory sessionFactory = HibernateUtil.getSessionFactory();
        Session session = sessionFactory.openSession();
        session.setFlushMode(FlushMode.MANUAL);
        ManagedSessionContext.bind(session);
        Transaction tx = null;
        try {
            tx = session.beginTransaction();

            session.save(entity);
            ManagedSessionContext.unbind(sessionFactory);
            session.flush();
            tx.commit(); // Flush happens automatically

        } catch (RuntimeException e) {
            tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    @Override
    @Transactional
    public Object getEntityByName(String column, String table, String login) {

        SessionFactory sessionFactory = HibernateUtil.getSessionFactory();

        Session session = sessionFactory.openSession();
        session.setFlushMode(FlushMode.MANUAL);
        ManagedSessionContext.bind(session);

        String table_capitalized = table.substring(0, 1).toUpperCase() + table.substring(1);
        String str_query = "from " + table_capitalized + " t where t." + column.toLowerCase() + " = :crit";
        Query query = session.createQuery(str_query);
        query.setParameter("crit", login);

        //ManagedSessionContext.unbind(sessionFactory);
        session.flush();
        
        if (query.list().size() == 0)
            return null;
        return query.list().get(0);
    }
    
    @Override
    @Transactional
    public Object getEntityById(String column, String table, Integer id) {

        SessionFactory sessionFactory = HibernateUtil.getSessionFactory();

        Session session = sessionFactory.openSession();
        session.setFlushMode(FlushMode.MANUAL);
        ManagedSessionContext.bind(session);

        String table_capitalized = table.substring(0, 1).toUpperCase() + table.substring(1);
        String str_query = "from " + table_capitalized + " t where t." + column.toLowerCase() + " = :crit";
        Query query = session.createQuery(str_query);
        query.setParameter("crit", id);

        //ManagedSessionContext.unbind(sessionFactory);
        session.flush();
        
        if (query.list().size() == 0)
            return null;
        return query.list().get(0);
    }

    @Override
    @Transactional
    public void updateEntity(Object entity) {
        SessionFactory sessionFactory = HibernateUtil.getSessionFactory();

        Session session = sessionFactory.openSession();
        session.setFlushMode(FlushMode.MANUAL);
        ManagedSessionContext.bind(session);
        Transaction tx = null;

        try {
            tx = session.beginTransaction();

            session.merge(entity);
            ManagedSessionContext.unbind(HibernateUtil.getSessionFactory());
            session.flush();
            tx.commit();
        } catch (RuntimeException e) {
            tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    @Override
    @Transactional
    public void findEntitiesMatchingPartialQuery(String field, String query_text, Object entity) {
        SessionFactory sessionFactory = HibernateUtil.getSessionFactory();

        Session session = sessionFactory.openSession();
        session.setFlushMode(FlushMode.MANUAL);
        ManagedSessionContext.bind(session);
        
        FullTextSession fullTextSession = org.hibernate.search.Search.getFullTextSession(session);
        Transaction tx = fullTextSession.beginTransaction();
        QueryBuilder qb = fullTextSession.getSearchFactory().buildQueryBuilder().forEntity(entity.getClass()).get();
        org.apache.lucene.search.Query query = qb.keyword().onFields(field).matching(query_text).createQuery();
        org.hibernate.Query hibQuery = fullTextSession.createFullTextQuery(query, entity.getClass());
        
        List result = hibQuery.list();
        if (result.size() > 0 )
            System.out.println(result.get(0));
    }

    @Override
    public List listEntity(String table) {
        SessionFactory sessionFactory = HibernateUtil.getSessionFactory();

        Session session = sessionFactory.openSession();
        session.setFlushMode(FlushMode.MANUAL);
        ManagedSessionContext.bind(session);

        String table_capitalized = table.substring(0, 1).toUpperCase() + table.substring(1);
        String str_query = "from " + table_capitalized;
        Query query = session.createQuery(str_query);
        
        //ManagedSessionContext.unbind(sessionFactory);
        session.flush();
        return query.list();
    }

    @Override
    public List listEntityByJoinCriteria(String table, String propertyName, String criteria_column, 
            String criteria_text) {
        SessionFactory sessionFactory = HibernateUtil.getSessionFactory();

        Session session = sessionFactory.openSession();
        session.setFlushMode(FlushMode.MANUAL);
        ManagedSessionContext.bind(session);

        String table_cap = table.substring(0, 1).toUpperCase() + table.substring(1);
        
        //String str_query = "select u from  Users u join u.userRoleses r where r.role='ROLE_ADMIN'";
        String str_query = "select u from " +  table_cap + " u join u. " + propertyName + " r where r." 
                + criteria_column + "='" + criteria_text + "'";
        
        Query query = session.createQuery(str_query);
        
        //ManagedSessionContext.unbind(sessionFactory);
        session.flush();
        List aux = query.list();
        return query.list();
    }
    
    @Override
    public List listEntityByJoinIdCriteria(String table, String propertyName, String criteria_column, 
            Integer id, String sndC, Integer sndQ) {
        SessionFactory sessionFactory = HibernateUtil.getSessionFactory();

        Session session = sessionFactory.openSession();
        session.setFlushMode(FlushMode.MANUAL);
        ManagedSessionContext.bind(session);

        String table_cap = table.substring(0, 1).toUpperCase() + table.substring(1);
        
        //String str_query = "select u from  Users u join u.userRoleses r where r.role='ROLE_ADMIN'";
        String str_query = "select u from " +  table_cap + " u join u. " + propertyName + " r where r." 
                + criteria_column + "=" + id + "AND u." + sndC+ "=" + sndQ;
        
        Query query = session.createQuery(str_query);
        
        //ManagedSessionContext.unbind(sessionFactory);
        session.flush();
        List aux = query.list();
        return query.list();
    }

    public void deleteEntity(Object entity) {
        SessionFactory sessionFactory = HibernateUtil.getSessionFactory();
        
        //Session session = sessionFactory.openSession();
        Session session = sessionFactory.getCurrentSession();
        session.setFlushMode(FlushMode.MANUAL);
        //ManagedSessionContext.bind(session);
        Transaction tx = null;

        try {
            tx = session.beginTransaction();
            //session.merge(entity);
            session.delete(entity);
            ManagedSessionContext.unbind(HibernateUtil.getSessionFactory());
            session.flush();
            tx.commit();
        } catch (RuntimeException e) {
            tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }
}
