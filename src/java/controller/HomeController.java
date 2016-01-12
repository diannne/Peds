/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.security.Principal;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Consultations;
import model.Kids;
import model.Parents;
import model.Pediatricians;
import model.Specialties;
import model.UserRoles;
import model.Users;
import model.Visit;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import service.DatabaseService;

/**
 *
 * @author Diana
 */
@Controller
public class HomeController {

    @RequestMapping(value={"", "/", "home"})
    public String homePage(ModelMap map, Principal user) {
        if (user != null){
            DatabaseService db = new DatabaseService();
            List roles =  db.listEntityByJoinCriteria("userRoles", "users", "username", user.getName());
            if (roles !=null && roles.size()>0){
                UserRoles role = (UserRoles) roles.get(0);
                if (role.getRole().equals("ROLE_USER")){
                    return "index";
                }
                
                if (role.getRole().equals("ROLE_SECRET")){
                    return "redirect:/secretary";
                }
                if (role.getRole().equals("ROLE_ADMIN")){
                    return "redirect:/admin";
                }
            }
        }
        map.addAttribute("message", "This is where the heart is");
        return "index";
    }

    @RequestMapping(value = "/admin", method = RequestMethod.GET)
    public ModelAndView firstAdminPage(ModelMap map) {
        return new ModelAndView("admin");
    }

    @RequestMapping(value = "/accessdenied", method = RequestMethod.GET)
    public ModelAndView acessdeniedPage(Principal user) {
        ModelAndView model = new ModelAndView();

        if (user != null) {
            model.addObject("msg", "Hi " + user.getName()
                    + ", you do not have permission to access this page!");
        } else {
            model.addObject("msg",
                    "Hi guest, you do not have permission to access this page!");
        }

        model.setViewName("accessdenied");
        return model;
    }
    
    @RequestMapping(value = "/accessdenied", method = RequestMethod.POST)
    @ResponseBody
    public String acessdeniedPage()
    {
        return "You just received accessdenied! :|";
    }
    
    @RequestMapping(value = "/change_pass/", method = RequestMethod.GET)
    public String passChange(Principal user) {
        if (user == null){
            return "index";
        }
        return "changePass";
    }
    
    @RequestMapping(value = "/change_pass/", method = RequestMethod.POST)

    public String passChangeForm(HttpServletRequest request, Principal user, 
            RedirectAttributes redirectAttrs) {
        String old_pass, new_pass1, new_pass2;
        old_pass = request.getParameter("old_password");
        new_pass1 = request.getParameter("new_password1");
        new_pass2 = request.getParameter("new_password2");
        //check that new passwords match
        if (new_pass1 == null ? new_pass2 != null : !new_pass1.equals(new_pass2)){
            //throw error
            redirectAttrs.addFlashAttribute("message", "The new passwords do not match!");
            return "redirect:/change_pass/";          
        }
        
        String username = user.getName();
        DatabaseService dbService = new DatabaseService();
        Users user_db = (Users) dbService.getEntityByName("username", "users", username);
        if ( !user_db.getPassword().equals(old_pass)){
            //throw error
            redirectAttrs.addFlashAttribute("message", "That is not the right old password!");
            return "redirect:/change_pass/";           
        }
        user_db.setPassword(new_pass1);
        dbService.updateEntity(user_db);
        redirectAttrs.addFlashAttribute("message", "You have successfully changed your password!");
        
        if (user != null) {
            DatabaseService db = new DatabaseService();
            List roles = db.listEntityByJoinCriteria("userRoles", "users", "username", user.getName());
            if (roles != null && roles.size() > 0) {
                UserRoles role = (UserRoles) roles.get(0);
                if (role.getRole().equals("ROLE_USER")) {
                    return "index";
                }

                if (role.getRole().equals("ROLE_SECRET")) {
                    return "redirect:/secretary";
                }
                if (role.getRole().equals("ROLE_ADMIN")) {
                    return "redirect:/admin";
                }
            }
        }
        return "index";
    }
    
    @RequestMapping(value = "/admin/search", method = RequestMethod.POST)
    public String searchForm(HttpServletRequest request) throws ClassNotFoundException, 
            InstantiationException, IllegalAccessException{
        String className = "model." + request.getParameter("class");
        String role = request.getParameter("role");
        String text = request.getParameter("q_text");
        System.out.println("entity is " + className);
        System.out.println("role is " + role);
        System.out.println("text is " + text);
        Object xyz = Class.forName(className).newInstance();
        
        DatabaseService dbService = new DatabaseService();
        dbService.findEntitiesMatchingPartialQuery("username", text, xyz);
        return "";
    }
    
    
    @RequestMapping(value = {"/specialties/"})
    public String viewSpecs(ModelMap map) {
        DatabaseService db = new DatabaseService();
        map.addAttribute("list", db.listEntity("specialties"));
        return "/parent/specialties";
    }
    
    @RequestMapping(value = {"/specialties/{id}/"})
    public String viewSpec(@PathVariable String id, 
            ModelMap map) {
        DatabaseService db = new DatabaseService();
        Object p = db.getEntityById("id", "specialties", Integer.parseInt(id));
        Specialties sp = (Specialties) p;
        map.addAttribute("peds_list", db.listEntityByJoinCriteria("pediatricians", "specialties", "name", sp.getName()));
        map.addAttribute("spec", sp.getName());
        return "/parent/specialty";
    }
 
    @RequestMapping(value = {"/pediatricians/"})
    public String viewPeds(ModelMap map) {
        DatabaseService db = new DatabaseService();
        map.addAttribute("list", db.listEntity("pediatricians"));
        return "/parent/pediatricians";
    }
    
    @RequestMapping(value = {"/pediatricians/{id}/"})
    public String viewPed(@PathVariable String id, 
            ModelMap map) {
        DatabaseService db = new DatabaseService();
        Object p = db.getEntityById("id", "pediatricians", Integer.parseInt(id));
        
        map.addAttribute("ped", (Pediatricians) p);
        return "/parent/pediatrician";
    }
    
    @RequestMapping(value = {"/contact/"})
    public String contact() {        
        return "/parent/contact";
    }
    
    @RequestMapping(value = {"/medical-history/"})
    public String viewMedHist(Principal user,  ModelMap map) {
        if (user == null){
            return "index";
        }                
        DatabaseService db = new DatabaseService();
        Object o = db.getEntityByName("email", "parents", user.getName());
        map.addAttribute("kids", ((Parents)o).getKidses());
        map.addAttribute("l_name", ((Parents)o).getLastName());
        return "/parent/history";
    }
    
    @RequestMapping(value = {"/medical-history/{id}/"})
    public String viewKid(@PathVariable String id, 
            ModelMap map, Principal user,
            RedirectAttributes redirectAttrs) throws ParseException {
        if (user == null){
            return "index";
        }  
        
        DatabaseService db = new DatabaseService();
        Object p = db.getEntityByName("email", "parents", user.getName());
        
        Object k = db.getEntityById("id", "kids", Integer.parseInt(id));
        
        map.addAttribute("parent", (Parents) p);
        map.addAttribute("kid", (Kids) k);
        Kids kid = (Kids)k;
        
        List<Visit> visits = new ArrayList<Visit>();
        for (Object c : kid.getConsultationses()) {
            Visit v = new Visit();
            v.setId(((Consultations) c).getId());
            v.setComments(((Consultations) c).getComments());
            v.setPrescription(((Consultations) c).getPrescription());
            v.setReason(((Consultations) c).getReason());
            String date = formatDate(((Consultations) c).getVisitDate()) + " "
                    + formatTime(((Consultations) c).getStartTime()) + " to "
                    + formatTime(((Consultations) c).getEndTime());
            
            v.setDate(date);
            Object o = db.getEntityById("id", "pediatricians", ((Consultations) c).getPediatricians().getId());
            if (o == null) {
                redirectAttrs.addFlashAttribute("message", "Cannot get pediatrician for this visit!");
                return "redirect:/medical-history/" + id;
            }
            v.setPed(((Pediatricians) o).getFirstName() + " " + ((Pediatricians) o).getLastName());
            v.setSpec(((Pediatricians) o).getSpecialties().getName());
            visits.add(v);
        }
        map.addAttribute("b_date", formatDate(kid.getBirthDate()));
        map.addAttribute("visits", visits);
        return "/parent/kid";
    }
    
    
    @RequestMapping(value = {"/medical-history/{id}/"}, method = RequestMethod.POST)
    public String updateKid(@PathVariable String id, 
            RedirectAttributes redirectAttrs,
            HttpServletRequest request) throws ParseException {
        
        String _discard = request.getParameter("_discard");
        if (_discard != null) {
            return "redirect:/medical-history/" + id + "/";
        }
        
        DatabaseService db = new DatabaseService();
        Object o = db.getEntityById("id", "kids", Integer.parseInt(id));
        if (o == null) {
            redirectAttrs.addFlashAttribute("message", "Entity selected has not been found!");
            return "redirect:/medical-history/" + id + "/";
        }
        Kids k = (Kids) o;
        
        k.setName(request.getParameter("f_name"));
        
        String str_date = request.getParameter("datetimepicker");

        DateFormat format = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
        Date date = format.parse(str_date);

        k.setBirthDate(date);
        
        db.updateEntity(k);

        redirectAttrs.addFlashAttribute("info", "Succesfully updated children information!");
        return "redirect:/medical-history/" + id + "/";
    }
    
    private String formatDate(Date visitDate) throws ParseException {
        DateFormat fromFormat = new SimpleDateFormat("yyyy-MM-dd");
        fromFormat.setLenient(false);
        DateFormat toFormat = new SimpleDateFormat("dd/MM/yyyy");
        toFormat.setLenient(false);
        String dateStr = visitDate.toString();
        Date date = fromFormat.parse(dateStr);
        return toFormat.format(date);

    }

    private String formatTime(Date visitTime) throws ParseException {
        DateFormat fromFormatTime = new SimpleDateFormat("HH:mm:ss");
        fromFormatTime.setLenient(false);
        DateFormat toFormatTime = new SimpleDateFormat("HH:mm");
        toFormatTime.setLenient(false);
        String time = visitTime.toString();
        Date date = fromFormatTime.parse(time);
        return toFormatTime.format(date);
    }
    
    
    @RequestMapping(value = {"/medical-history/addkid/"}, method = RequestMethod.GET)
    public String addKidForm(Principal user, 
            RedirectAttributes redirectAttrs,
            ModelMap map) {
        if(user == null){
            return "redirect:/medical-history/";
        }
        
        DatabaseService db = new DatabaseService();
        Object o = db.getEntityByName("email", "parents", user.getName());
        if (o == null) {
            redirectAttrs.addFlashAttribute("message", "Entity selected has not been found!");
            return "redirect:/medical-history/";
        }
        Parents p = (Parents) o;
        map.addAttribute("parent",  p);
        
        return "/parent/addkid";
    }
    
    @RequestMapping(value = {"/medical-history/addkid/"}, method = RequestMethod.POST)
    public String addKid(RedirectAttributes redirectAttrs,
            HttpServletRequest request,
            Principal user) throws ParseException {
        
        if (user == null){
            return "redirect:/medical-history/addkid/";
        }
        String _discard = request.getParameter("_discard");
        if (_discard != null) {
            return "redirect:/medical-history/addkid/";
        }
        DatabaseService db = new DatabaseService();
        Object o = db.getEntityByName("email", "parents", user.getName());
        if (o == null) {
            redirectAttrs.addFlashAttribute("message", "Entity seleacted has not been found!");
            return "redirect:/medical-history/addkid/";
        }
        
        Parents p = (Parents) o;
        Kids kid = new Kids();
        kid.setName(request.getParameter("f_name"));
        
        DateFormat format = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
        Date date = format.parse(request.getParameter("datetimepicker"));
        kid.setBirthDate(date);
        kid.setParents(p);

        p.addKid(kid);
        db.updateEntity(p);
        redirectAttrs.addFlashAttribute("info", "Successfully added new kid!");

        return "redirect:/medical-history/";
    }
}
