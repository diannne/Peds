/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package service;

import java.util.List;

/**
 *
 * @author Diana
 */
public interface IDatabaseService {
    
    //meant to save an entity to the Database
    public void saveEntity(Object entity);
    //return entity from database
    public Object getEntityByName(String column, String table, String login);
    
    public List listEntity(String table);
    
    public List listEntityByJoinCriteria(String table, String propName, String crit_column, String crit_text);
    
    public void updateEntity(Object entity);
    
    public void findEntitiesMatchingPartialQuery(String field, String query_text, Object entity);
    
    public Object getEntityById(String column, String table, Integer id);
    
    public List listEntityByJoinIdCriteria(String table, String propertyName, String criteria_column, 
            Integer id, String sndc, Integer sndt);
}
