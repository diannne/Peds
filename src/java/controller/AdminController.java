/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import javax.servlet.http.HttpServletRequest;
import model.Consultations;
import model.Pediatricians;
import model.Specialties;
import model.UserRoles;
import model.Users;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.HandlerMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import service.DatabaseService;

/**
 *
 * @author Diana
 */
@Controller
public class AdminController {

    @RequestMapping(value = {"/admin/users", "/admin/users/admin", "/admin/users/secretary"})
    public String usersManagementPage(ModelMap map) {
        return "/admin/users/main";
    }

    @RequestMapping(value = {"/admin/peds", "/admin/peds/doctor", "/admin/peds/specialty",})
    public String pedsManagementPage(ModelMap map) {
        return "/admin/pediatrics/main";
    }

    @RequestMapping(value = {"/admin/users/admin/change"})
    public String changeAdminsPage(ModelMap map) {
        DatabaseService db = new DatabaseService();
        map.addAttribute("list", db.listEntityByJoinCriteria("users", "userRoleses", "role", "ROLE_ADMIN"));
        return "/admin/users/admin/change";
    }

    @RequestMapping(value = {"/admin/users/secretary/change"})
    public String changeSecretPage(ModelMap map) {
        DatabaseService db = new DatabaseService();
        map.addAttribute("list", db.listEntityByJoinCriteria("users", "userRoleses", "role", "ROLE_SECRET"));
        return "/admin/users/secretary/change";
    }

    @RequestMapping(value = {"/admin/peds/specialty/change"})
    public String changeSpecPage(ModelMap map) {
        DatabaseService db = new DatabaseService();
        map.addAttribute("list", db.listEntity("specialties"));
        return "/admin/pediatrics/specialty/change";
    }

    @RequestMapping(value = {"/admin/users/admin/add"})
    public String addAdminsPage(ModelMap map) {
        return "/admin/users/admin/add";
    }

    @RequestMapping(value = {"/admin/users/admin/change/{username}",
        "/admin/users/secretary/change/{username}"}, method = RequestMethod.GET)
    public String updateForm(@PathVariable String username,
            HttpServletRequest request,
            RedirectAttributes redirectAttrs,
            ModelMap map) {

        DatabaseService db = new DatabaseService();
        Object o = db.getEntityByName("username", "users", username);
        Users u = (Users) o;

        map.addAttribute("username", u.getUsername());
        map.addAttribute("pass", u.getPassword());
        map.addAttribute("enabled", u.getEnabled());

        String str = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
        if (str.contains("secretary")) {
            return "/admin/users/secretary/update";
        } else {
            return "/admin/users/admin/update";
        }
    }

    @RequestMapping(value = {"/admin/users/admin/change/{username}",
        "/admin/users/secretary/change/{username}"}, method = RequestMethod.POST)
    public String updateFormPost(@PathVariable String username,
            HttpServletRequest request,
            RedirectAttributes redirectAttrs) {
        String _discard = request.getParameter("_discard");
        String str = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
        
        if (_discard != null) {
            if (str.contains("secretary")) {
            return "redirect:/admin/users/secretary/change/" + username;
        } else {
            return "redirect:/admin/users/admin/change/" + username;
        }
        }

        DatabaseService db = new DatabaseService();
        Object o = db.getEntityByName("username", "users", username);
        Users u = (Users) o;
        String[] enabled = request.getParameterValues("enabled");
        if (enabled == null) {
            byte en = 0;
            u.setEnabled(en);
        }
        db.updateEntity(u);

        if (str.contains("secretary")) {
            return "redirect:/admin/users/secretary/change/" + username;
        } else {
            return "redirect:/admin/users/admin/change/" + username;
        }
    }

    @RequestMapping(value = {"/admin/users/secretary/add"})
    public String addSecretPage(ModelMap map) {
        return "/admin/users/secretary/add";
    }

    @RequestMapping(value = {"/admin/peds/doctor/add"})
    public String addDoctorPage(ModelMap map) {
        DatabaseService db = new DatabaseService();
        map.addAttribute("list", db.listEntity("specialties"));
        return "/admin/pediatrics/doctor/add";
    }

    @RequestMapping(value = {"/admin/peds/specialty/add"})
    public String addSpecialtyPage(ModelMap map) {
        return "/admin/pediatrics/specialty/add";
    }

    @RequestMapping(value = {"/admin/peds/kid/add"})
    public String addKidPage(ModelMap map) {
        return "/admin/pediatrics/kid/add";
    }

    @RequestMapping(value = {"/admin/peds/consult/add"})
    public String addConsultPage(ModelMap map) {
        return "/admin/pediatrics/consult/add";
    }

    @RequestMapping(value = {"/admin/users/admin/runaction", "/admin/users/secretary/runaction"},
            method = RequestMethod.POST)
    public String runactionForm(HttpServletRequest request, RedirectAttributes redirectAttrs) {

        //redirect to root page
        String str = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
        String newstr = str;
        if (null != str && str.length() > 0) {
            int endIndex = str.lastIndexOf("/");
            if (endIndex != -1) {
                newstr = str.substring(0, endIndex);
            }
        }

        String[] usernames = request.getParameterValues("_selected_action");
        if (usernames == null) {
            redirectAttrs.addFlashAttribute("message", "You did not select any rows!");

            return "redirect:" + newstr + "/change";
        }
        String[] action = request.getParameterValues("action");
        if (action[0].equals("none_selected")) {
            redirectAttrs.addFlashAttribute("message", "You did not select any action to be done!");
            return "redirect:" + newstr + "/change";
        }

        DatabaseService db = new DatabaseService();
        Integer count = 0;
        for (String u : usernames) {
            Users user_db = (Users) db.getEntityByName("username", "users", u);
            if (action[0].equals("delete_selected")) {
                db.deleteEntity(user_db);
                count++;
            }
        }
        redirectAttrs.addFlashAttribute("info", "You have successfully deleted " + count.toString() + " rows!");

        return "redirect:" + newstr + "/change";
    }

    @RequestMapping(value = {"/admin/users/admin/add", "/admin/users/secretary/add"},
            method = RequestMethod.POST)
    public String addForm(HttpServletRequest request, RedirectAttributes redirectAttrs) {
        String username, pass1, pass2, role;
        username = request.getParameter("username");
        pass1 = request.getParameter("pass1");
        pass2 = request.getParameter("pass2");
        role = request.getParameter("role");

        String redirect = "redirect:"
                + (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);

        if (pass1 == null || pass2 == null) {
            redirectAttrs.addFlashAttribute("message", "Password fields must not be empty");
            return redirect;
        }
        //check that new passwords match
        if (pass1 == null ? pass2 != null : !pass1.equals(pass2)) {
            //throw error
            redirectAttrs.addFlashAttribute("message", "The two passwords do not match!");
            return redirect;
        }

        DatabaseService dbService = new DatabaseService();
        Users user_db = (Users) dbService.getEntityByName("username", "users", username);
        //check that the user does not exist
        if (user_db != null) {

            //throw error
            redirectAttrs.addFlashAttribute("message", "User " + username + " already exists!");
            return redirect;

        }

        user_db = new Users();
        user_db.setPassword(pass1);
        user_db.setUsername(username);
        byte enabled = 1;
        user_db.setEnabled(enabled);

        UserRoles roleDb = new UserRoles();
        Set userRoleses = new HashSet(0);
        roleDb.setRole(role);
        roleDb.setUsers(user_db);
        userRoleses.add(roleDb);
        user_db.setUserRoleses(userRoleses);

        dbService.saveEntity(user_db);

        redirectAttrs.addFlashAttribute("info", "You have successfully added a new user with role " + role);
        //redirect to root page
        String str = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
        String newstr = str;
        if (null != str && str.length() > 0) {
            int endIndex = str.lastIndexOf("/");
            if (endIndex != -1) {
                newstr = str.substring(0, endIndex); // not forgot to put check if(endIndex != -1)
            }
        }
        redirect = "redirect:" + newstr + "/change";
        return redirect;
    }

    @RequestMapping(value = {"/admin/users/admin/{id}"}, method = RequestMethod.GET)
    public String changeEntity(RedirectAttributes redirectAttrs, HttpServletRequest request) {
        String test = request.getParameter("data1");
        return test;
    }

    @RequestMapping(value = {"/admin/peds/doctor/add"}, method = RequestMethod.POST)
    public String addDrForm(HttpServletRequest request, RedirectAttributes redirectAttrs) {
        String str = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
        String newstr = str;
        if (null != str && str.length() > 0) {
            int endIndex = str.lastIndexOf("/");
            if (endIndex != -1) {
                newstr = str.substring(0, endIndex);
            }
        }
        String f_name, l_name, grade, spec;
        f_name = request.getParameter("f_name");
        l_name = request.getParameter("l_name");
        spec = request.getParameterValues("action")[0];
        grade = request.getParameter("grade");

        DatabaseService dbService = new DatabaseService();

        //check that specialty already exists
        Object o = dbService.getEntityByName("name", "specialties", spec);
        if (o == null) {
            redirectAttrs.addFlashAttribute("message", "Did not find the specialty chosen!");
            return "redirect:" + newstr + "/change";
        }

        //Set<Consultations> consultationses = new HashSet(0);
        Specialties sp = (Specialties) o;
        Pediatricians dr = new Pediatricians();
        dr.setSpecialties(sp);
        dr.setFirstName(f_name);
        dr.setLastName(l_name);
        dr.setGrade(grade);

        sp.addPediatrician(dr);
        dbService.updateEntity(sp);
        redirectAttrs.addFlashAttribute("info", "You have successfully added a new doctor!");
        //redirect to change page

        return "redirect:" + newstr + "/change";
    }

    @RequestMapping(value = {"/admin/peds/doctor/change"})
    public String changeDoctorPage(ModelMap map) {
        DatabaseService db = new DatabaseService();
        List drs = db.listEntity("pediatricians");
        map.addAttribute("list", drs);
        return "/admin/pediatrics/doctor/change";
    }

    @RequestMapping(value = {"/admin/peds/doctor/change/{id}"})
    public String updateDoctor(@PathVariable String id, ModelMap map) {
        DatabaseService db = new DatabaseService();
        Pediatricians p = (Pediatricians) db.getEntityById("id", "pediatricians", Integer.parseInt(id));
        map.addAttribute("f_name", p.getFirstName());
        map.addAttribute("l_name", p.getLastName());
        map.addAttribute("grade", p.getGrade());
        map.addAttribute("spec", p.getSpecialties().getName());
        List drs = db.listEntity("specialties");
        map.addAttribute("list", drs);
        return "/admin/pediatrics/doctor/update";
    }

    @RequestMapping(value = {"/admin/peds/specialty/change/{id}"})
    public String updateSpec(@PathVariable String id, ModelMap map) {
        DatabaseService db = new DatabaseService();
        Specialties sp = (Specialties) db.getEntityById("id", "specialties", Integer.parseInt(id));
        map.addAttribute("name", sp.getName());
        return "/admin/pediatrics/specialty/update";
    }

    @RequestMapping(value = {"/admin/peds/doctor/change/{id}"}, method = RequestMethod.POST)
    public String updateDoctorPost(@PathVariable String id, HttpServletRequest request,
            RedirectAttributes redirectAttrs) {
        String discard = request.getParameter("_discard");
        if (discard != null) {
            return "redirect:/admin/peds/doctor/change/" + id;
        }
        DatabaseService db = new DatabaseService();
        Pediatricians p = (Pediatricians) db.getEntityById("id", "pediatricians", Integer.parseInt(id));

        String firstName = request.getParameter("f_name");
        String lastName = request.getParameter("l_name");
        String grade = request.getParameter("grade");
        String spec = request.getParameterValues("action")[0];

        Specialties sp_new = (Specialties) db.getEntityByName("name", "specialties", spec);
        Specialties sp_old = p.getSpecialties();
        if (sp_old == null || sp_new == null) {
            redirectAttrs.addFlashAttribute("message", "Cannot get specialty for this doctor!");
            return "redirect:/admin/peds/doctor/change/" + id;
        }
        p.setFirstName(firstName);
        p.setLastName(lastName);
        p.setGrade(grade);
        sp_old.removePediatrician(p);
        p.setSpecialties(sp_new);
        sp_new.addPediatrician(p);
        db.updateEntity(sp_new);
        redirectAttrs.addFlashAttribute("info", "You have successfully updated this doctor!");
        return "redirect:/admin/peds/doctor/change/" + id;
    }

    @RequestMapping(value = {"/admin/peds/specialty/change/{id}"}, method = RequestMethod.POST)
    public String updateSpecialtyPost(@PathVariable String id, HttpServletRequest request,
            RedirectAttributes redirectAttrs) {
        String discard = request.getParameter("_discard");
        if (discard != null) {
            return "redirect:/admin/peds/specialty/change/" + id;
        }
        DatabaseService db = new DatabaseService();
        Specialties sp = (Specialties) db.getEntityById("id", "specialties", Integer.parseInt(id));

        String name = request.getParameter("name");
        sp.setName(name);
        db.updateEntity(sp);
        redirectAttrs.addFlashAttribute("info", "You have successfully updated this specialty!");
        return "redirect:/admin/peds/specialty/change/" + id;
    }

    @RequestMapping(value = {"/admin/peds/specialty/add"}, method = RequestMethod.POST)
    public String addSpecForm(HttpServletRequest request, RedirectAttributes redirectAttrs) {
        String name = request.getParameter("name");

        DatabaseService dbService = new DatabaseService();

        Specialties sp = new Specialties();
        sp.setName(name);

        dbService.saveEntity(sp);

        redirectAttrs.addFlashAttribute("info", "You have successfully added a new specialty!");
        //redirect to root page
        String str = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
        String newstr = str;
        if (null != str && str.length() > 0) {
            int endIndex = str.lastIndexOf("/");
            if (endIndex != -1) {
                newstr = str.substring(0, endIndex);
            }
        }
        return "redirect:" + newstr + "/change";
    }

    @RequestMapping(value = {"/admin/peds/{entity}/runaction"}, method = RequestMethod.POST)
    public String deleteActionForm(@PathVariable String entity, HttpServletRequest request,
            RedirectAttributes redirectAttrs) {

        String[] checkboxes = request.getParameterValues("_selected_action");
        if (checkboxes == null) {
            redirectAttrs.addFlashAttribute("message", "You did not select any rows!");
            return "redirect:/admin/peds/" + entity + "/change";
        }
        String[] action = request.getParameterValues("action");
        if (action[0].equals("none_selected")) {
            redirectAttrs.addFlashAttribute("message", "You did not select any action to be done!");
            return "redirect:/admin/peds/" + entity + "/change";
        }

        String table = request.getParameter("table");
        String column = request.getParameter("column");
        DatabaseService db = new DatabaseService();
        Integer count = 0;
        for (String u : checkboxes) {
            Object o = db.getEntityById(column, table, Integer.parseInt(u));
            if (o == null) {
                redirectAttrs.addFlashAttribute("message", "Entity selected has not been found!");
                return "redirect:/admin/peds/" + entity + "/change";
            }
            if (action[0].equals("delete_selected")) {
                db.deleteEntity(o);
                count++;
            }
        }
        redirectAttrs.addFlashAttribute("info", "You have successfully deleted " + count.toString() + " rows!");
        //redirect to root page        
        return "redirect:/admin/peds/" + entity + "/change";
    }
}
