/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import com.sun.xml.wss.util.DateUtils;
import java.sql.Time;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.regex.Pattern;
import javax.servlet.http.HttpServletRequest;
import model.Consultations;
import model.Kids;
import model.Parents;
import model.Pediatricians;
import model.Specialties;
import model.UserRoles;
import model.Users;
import model.Visit;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.HandlerMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import service.DatabaseService;

/**
 *
 * @author Diana
 */
@Controller
public class SecretController {

    @RequestMapping(value = {"/secretary"})
    public String secretManagementPage(ModelMap map) {
        DatabaseService db = new DatabaseService();
        List results = (List) map.get("list");
        if(results == null)
            map.addAttribute("list", db.listEntity("parents"));
        else
            map.addAttribute("list", results);
        return "secret";
    }

    @RequestMapping(value = {"/secret/register"})
    public String secretRegister(ModelMap map) {
        return "redirect:/register";
    }

    @RequestMapping(value = {"/secret/patient/runaction"}, method = RequestMethod.POST)
    public String deleteactionForm(HttpServletRequest request, RedirectAttributes redirectAttrs) {

        String[] usernames = request.getParameterValues("_selected_action");
        if (usernames == null) {
            redirectAttrs.addFlashAttribute("message", "You did not select any rows!");
            return "redirect:/secretary";
        }
        String[] action = request.getParameterValues("action");
        if (action[0].equals("none_selected")) {
            redirectAttrs.addFlashAttribute("message", "You did not select any action to be done!");
            return "redirect:/secretary";
        }

        String table = request.getParameter("table");
        String column = request.getParameter("column");
        DatabaseService db = new DatabaseService();
        Integer count = 0;
        for (String u : usernames) {
            Object o = db.getEntityById(column, table, Integer.parseInt(u));
            if (o == null) {
                redirectAttrs.addFlashAttribute("message", "Entity selected has not been found!");
                return "redirect:/secretary";
            }
            if (action[0].equals("delete_selected")){
                db.deleteEntity(o);
                count++;
            }
        }
        redirectAttrs.addFlashAttribute("info", "You have successfully deleted "
                + count.toString() + " rows!");
        //redirect to root page        
        return "redirect:/secretary";
    }

    @RequestMapping(value = {"/secret/patient/{id}"}, method = RequestMethod.GET)
    public String seePatientForm(@PathVariable String id, RedirectAttributes redirectAttrs,
            ModelMap map) {
        DatabaseService db = new DatabaseService();
        Object o = db.getEntityById("id", "parents", Integer.parseInt(id));
        if (o == null) {
            redirectAttrs.addFlashAttribute("message", "Entity selected has not been found!");
            return "redirect:/secretary";
        }
        Parents p = (Parents) o;
        map.addAttribute("id", p.getId());
        map.addAttribute("f_name", p.getFirstName());
        map.addAttribute("l_name", p.getLastName());
        map.addAttribute("email", p.getEmail());
        map.addAttribute("tele", p.getTelephone());
        map.addAttribute("addr", p.getAddress());
        map.addAttribute("city", p.getCity());
        map.addAttribute("kids", p.getKidses());

        return "secret/patientForm";
    }

    @RequestMapping(value = {"/secret/patient/{id}"}, method = RequestMethod.POST)
    public String updatePatient(@PathVariable String id, RedirectAttributes redirectAttrs,
            HttpServletRequest request) {
        DatabaseService db = new DatabaseService();
        Object o = db.getEntityById("id", "parents", Integer.parseInt(id));
        if (o == null) {
            redirectAttrs.addFlashAttribute("message", "Entity selected has not been found!");
            return "redirect:/secretary";
        }
        Parents p = (Parents) o;
        p.setFirstName(request.getParameter("f_name"));
        p.setLastName(request.getParameter("l_name"));
        p.setEmail(request.getParameter("email"));
        p.setTelephone(request.getParameter("tele"));
        p.setCity(request.getParameter("city"));
        p.setAddress(request.getParameter("addr"));
        db.updateEntity(p);

        redirectAttrs.addFlashAttribute("info", "Succesfully updated patient information!");
        return "redirect:/secret/patient/" + id;
    }

    @RequestMapping(value = {"/secret/patient/{id}/kid/add"}, method = RequestMethod.GET)
    public String addKidForm(@PathVariable String id, RedirectAttributes redirectAttrs,
            ModelMap map) {
        DatabaseService db = new DatabaseService();
        Object o = db.getEntityById("id", "parents", Integer.parseInt(id));
        if (o == null) {
            redirectAttrs.addFlashAttribute("message", "Entity selected has not been found!");
            return "redirect:/secretary";
        }
        Parents p = (Parents) o;
        map.addAttribute("fp_name", p.getFirstName());
        map.addAttribute("lp_name", p.getLastName());
        map.addAttribute("id", p.getId());
        return "secret/addkid";
    }

    @RequestMapping(value = {"/secret/patient/{id}/kid/add"}, method = RequestMethod.POST)
    public String addKid(@PathVariable String id, RedirectAttributes redirectAttrs,
            HttpServletRequest request) throws ParseException {

        DatabaseService db = new DatabaseService();
        Object o = db.getEntityById("id", "parents", Integer.parseInt(id));
        if (o == null) {
            redirectAttrs.addFlashAttribute("message", "Entity seleacted has not been found!");
            return "redirect:/secretary";
        }
        Parents p = (Parents) o;
        Kids kid = new Kids();
        kid.setName(request.getParameter("f_name"));
        //DateFormat format = new SimpleDateFormat("MMMM d, yyyy", Locale.ENGLISH);
        DateFormat format = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
        Date date = format.parse(request.getParameter("b_date"));
        kid.setBirthDate(date);
        kid.setParents(p);

        p.addKid(kid);
        db.updateEntity(p);
        redirectAttrs.addFlashAttribute("info", "Successfully added new kid!");

        return "redirect:/secret/patient/" + id;
    }

    @RequestMapping(value = {"/secret/patient/{id}/kid/runaction"}, method = RequestMethod.POST)
    public String secretRunActionForm(@PathVariable String id, 
            HttpServletRequest request,
            RedirectAttributes redirectAttrs) {

        String[] action = request.getParameterValues("action");
        if (action == null) {
            redirectAttrs.addFlashAttribute("message", "Cannot find any action!");
            return "redirect:/secret/patient/" + id;
        }
        String[] selected_fields = request.getParameterValues("_selected_action");
        if (selected_fields == null) {
            redirectAttrs.addFlashAttribute("message", "Cannot find any select parameters!");
            return "redirect:/secret/patient/" + id;
        }

        DatabaseService db = new DatabaseService();

        Integer count = 0;
        for (String u : selected_fields) {

            if (action[0].equals("delete_selected")) {
                List kids = db.listEntityByJoinIdCriteria("kids", "parents", "id", Integer.parseInt(id), "id", Integer.parseInt(u));
                if (kids != null && kids.size() > 0) {
                    db.deleteEntity(kids.get(0));
                    count++;
                }
            } else {
                redirectAttrs.addFlashAttribute("message", "Please select an action to apply!");
                return "redirect:/secret/patient/" + id;

            }
        }
        redirectAttrs.addFlashAttribute("info", "You have successfully deleted " + count.toString() + " rows!");

        return "redirect:/secret/patient/" + id;
    }

    @RequestMapping(value = {"/secret/patient/{pid}/kid/{kid}"}, method = RequestMethod.GET)
    public String addKidForm(@PathVariable String pid, @PathVariable String kid,
            RedirectAttributes redirectAttrs,
            ModelMap map) throws ParseException {
        DatabaseService db = new DatabaseService();
        List kids = db.listEntityByJoinIdCriteria("kids", "parents", "id", Integer.parseInt(pid), "id", Integer.parseInt(kid));
        if (kids == null) {
            redirectAttrs.addFlashAttribute("message", "Null object returned!!");
            return "redirect:/secret/patient/" + pid;
        }
        if (kids.size() != 1) {
            redirectAttrs.addFlashAttribute("message", "More than one or no child found with this name!");
            return "redirect:/secret/patient/" + pid;
        }

        Kids k = (Kids) kids.get(0);
        Object o = db.getEntityById("id", "parents", Integer.parseInt(pid));
        if (o == null) {
            redirectAttrs.addFlashAttribute("message", "Cannot get parrent for this child!");
            return "redirect:/secret/patient/" + pid;
        }
        Parents p = (Parents) o;

        map.addAttribute("f_name", k.getName());
        map.addAttribute("l_name", p.getLastName());
        map.addAttribute("fp_name", p.getFirstName());
        map.addAttribute("lp_name", p.getLastName());
        
        map.addAttribute("pid", p.getId());
        map.addAttribute("kid", k.getId());
        map.addAttribute("b_date", formatDate(k.getBirthDate()));
        
        List<Visit> visits = new ArrayList<Visit>();
        for (Object c : k.getConsultationses()) {
            Visit v = new Visit();
            v.setId(((Consultations) c).getId());
            v.setComments(((Consultations) c).getComments());
            v.setPrescription(((Consultations) c).getPrescription());
            v.setReason(((Consultations) c).getReason());
            String date = formatDate(((Consultations) c).getVisitDate()) + " "
                    + formatTime(((Consultations) c).getStartTime()) + " to "
                    + formatTime(((Consultations) c).getEndTime());
            
            v.setDate(date);
            o = db.getEntityById("id", "pediatricians", ((Consultations) c).getPediatricians().getId());
            if (o == null) {
                redirectAttrs.addFlashAttribute("message", "Cannot get pediatrician for this visit!");
                return "redirect:/secret/patient/" + pid;
            }
            v.setPed(((Pediatricians) o).getFirstName() + " " + ((Pediatricians) o).getLastName());
            v.setSpec(((Pediatricians) o).getSpecialties().getName());
            visits.add(v);
        }

        map.addAttribute("visits", visits);
        return "secret/kidform";
    }

    @RequestMapping(value = {"/secret/patient/{pid}/kid/{kid}/visit/add"}, method = RequestMethod.GET)
    public String addVisitForm(@PathVariable String pid, @PathVariable String kid,
            RedirectAttributes redirectAttrs,
            ModelMap map) {
        DatabaseService db = new DatabaseService();
        Object o = db.getEntityById("id", "kids", Integer.parseInt(kid));
        if (o == null) {
            redirectAttrs.addFlashAttribute("message", "Entity selected has not been found!");
            return "redirect:/secretary";
        }
        Object p = db.getEntityById("id", "parents", Integer.parseInt(pid));
        if (p == null) {
            redirectAttrs.addFlashAttribute("message", "Entity selected has not been found!");
            return "redirect:/secretary";
        }
        Kids k = (Kids) o;
        Parents pk = (Parents) p;
        map.addAttribute("fp_name", k.getName());
        map.addAttribute("lp_name", pk.getLastName());
        map.addAttribute("id", k.getId());
        List specs = db.listEntity("specialties");
        map.addAttribute("spec_list", specs);
        String spec = (String) map.get("spec");
        String doc = (String) map.get("doc");

        if (spec != null) {
            map.addAttribute("peds_list", db.listEntityByJoinCriteria("pediatricians", "specialties", "name", spec));
            map.addAttribute("spec", spec);
            if (doc != null) {
                map.addAttribute("doc", doc);
            }

        } else if (specs.size() > 0) {
            spec = ((Specialties) specs.get(0)).getName();
            map.addAttribute("spec", spec);
            map.addAttribute("peds_list", db.listEntityByJoinCriteria("pediatricians", "specialties", "name", spec));
            if (doc != null) {
                map.addAttribute("doc", "");
            }

        }
        return "secret/addvisit";
    }

    @RequestMapping(value = {"/secret/patient/{pid}/kid/{kid}/visit/add"}, method = RequestMethod.POST)
    public String addVisitFormPost(@PathVariable String pid,
            @PathVariable String kid,
            HttpServletRequest request,
            RedirectAttributes redirectAttrs) throws ParseException {
        String spec_name = request.getParameterValues("action")[0];
        String _save = request.getParameter("_save");
        String _discard = request.getParameter("_discard");

        String[] doc_ids = request.getParameterValues("ped_action");
        String doc_id = "";
        if (doc_ids != null) {
            doc_id = doc_ids[0];
        }

        String str = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);

        if (_save == null && _discard == null && spec_name != null) {
            redirectAttrs.addFlashAttribute("spec", spec_name);
        } else if (_discard != null) {
            redirectAttrs.addFlashAttribute("spec", spec_name);
            redirectAttrs.addFlashAttribute("doc", doc_id);
            return "redirect:" + str;
        } else if (_save != null) {
            String str_date = request.getParameter("datetimepicker1");
            
            DateFormat format = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
            Date date = format.parse(str_date);

            DateFormat formatTime = new SimpleDateFormat("HH:mm");
            String s_time = request.getParameter("datetimepicker2");
            String e_time = request.getParameter("datetimepicker3");
            
            long ms = formatTime.parse(s_time).getTime();
            Time start = new Time(ms);
            ms = formatTime.parse(e_time).getTime();
            Time end = new Time(ms);
            if (start.after(end)) {
                redirectAttrs.addFlashAttribute("message", "Start time is after end time");
                redirectAttrs.addFlashAttribute("spec", spec_name);
                redirectAttrs.addFlashAttribute("doc", doc_id);
                return "redirect:" + str;
            }

            DatabaseService db = new DatabaseService();
            Object o = db.getEntityById("id", "kids", Integer.parseInt(kid));
            Kids k = (Kids) o;
            o = db.getEntityById("id", "pediatricians", Integer.parseInt(doc_id));
            Pediatricians p = (Pediatricians) o;
            Consultations visit = new Consultations(k, p, date, start, end, "", "", "");
            k.addConsultation(visit);
            p.addConsultation(visit);
            db.updateEntity(k);
            db.updateEntity(p);
        }

        return "redirect:" + str;
    }

    @RequestMapping(value = {"/secret/patient/{pid}/kid/{kid}/visit/{vid}"}, method = RequestMethod.GET)
    public String visitForm(@PathVariable String pid,
            @PathVariable String kid,
            @PathVariable String vid,
            RedirectAttributes redirectAttrs,
            ModelMap map) throws ParseException {
        DatabaseService db = new DatabaseService();
        Object o = db.getEntityById("id", "kids", Integer.parseInt(kid));
        if (o == null) {
            redirectAttrs.addFlashAttribute("message", "Entity selected has not been found!");
            return "redirect:/secretary";
        }
        Kids k = (Kids) o;
        Object p = db.getEntityById("id", "parents", Integer.parseInt(pid));
        if (p == null) {
            redirectAttrs.addFlashAttribute("message", "Entity selected has not been found!");
            return "redirect:/secretary";
        }
        Parents pk = (Parents) p;

        o = db.getEntityById("id", "consultations", Integer.parseInt(vid));
        if (o == null) {
            redirectAttrs.addFlashAttribute("message", "Entity selected has not been found!");
            return "redirect:/secretary";
        }
        Consultations c = (Consultations) o;

        map.addAttribute("f_name", k.getName());

        map.addAttribute("fp_name", pk.getFirstName());
        map.addAttribute("lp_name", pk.getLastName());
        map.addAttribute("kid", k.getId());
        map.addAttribute("pid", pk.getId());

        map.addAttribute("comm", c.getComments());
        map.addAttribute("reason", c.getReason());
        map.addAttribute("pres", c.getPrescription());

        DateFormat fromFormat = new SimpleDateFormat("yyyy-MM-dd");
        fromFormat.setLenient(false);
        DateFormat toFormat = new SimpleDateFormat("dd/MM/yyyy");
        toFormat.setLenient(false);
        String dateStr = c.getVisitDate().toString();
        Date date = fromFormat.parse(dateStr);
        map.addAttribute("date", toFormat.format(date));
        DateFormat fromFormatTime = new SimpleDateFormat("HH:mm:ss");
        fromFormatTime.setLenient(false);
        DateFormat toFormatTime = new SimpleDateFormat("HH:mm");
        toFormatTime.setLenient(false);
        String time = c.getStartTime().toString();
        date = fromFormatTime.parse(time);
        map.addAttribute("s_time", toFormatTime.format(date));
        time = c.getEndTime().toString();
        date = fromFormatTime.parse(time);
        map.addAttribute("e_time", toFormatTime.format(date));

        List specs = db.listEntity("specialties");
        map.addAttribute("spec_list", specs);
        String spec = (String) map.get("spec");
        String doc = (String) map.get("doc");

        //if this is a redirect and spec is received
        if (spec != null) {
            map.addAttribute("peds_list", db.listEntityByJoinCriteria("pediatricians", "specialties", "name", spec));
            map.addAttribute("spec", spec);
            if (doc != null) {
                map.addAttribute("doc", doc);
            }

        } else {
            spec = c.getPediatricians().getSpecialties().getName();
            map.addAttribute("doc", c.getPediatricians().getFirstName() + " " + c.getPediatricians().getLastName());
            map.addAttribute("spec", spec);
            map.addAttribute("peds_list", db.listEntityByJoinCriteria("pediatricians", "specialties", "name", spec));
        }
        return "secret/visitform";
    }

    @RequestMapping(value = {"/secret/patient/{pid}/kid/{kid}/visit/{vid}"}, method = RequestMethod.POST)
    public String editVisitFormPost(@PathVariable String pid,
            @PathVariable String kid,
            @PathVariable String vid,
            HttpServletRequest request,
            RedirectAttributes redirectAttrs) throws ParseException {
        String spec_name = request.getParameterValues("action")[0];
        String _save = request.getParameter("_save");
        String _discard = request.getParameter("_discard");

        String[] doc_ids = request.getParameterValues("ped_action");
        String doc_id = "";
        if (doc_ids != null) {
            doc_id = doc_ids[0];
        }

        String str = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);

        if (_save == null && _discard == null && spec_name != null) {
            redirectAttrs.addFlashAttribute("spec", spec_name);
        } else if (_discard != null) {
            return "redirect:" + str;
        } else if (_save != null) {
            String str_date = request.getParameter("datetimepicker1");
            DateFormat format = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);

            Date date = format.parse(str_date);
            DateFormat formatTime = new SimpleDateFormat("HH:mm");
            String s_time = request.getParameter("datetimepicker2");
            String e_time = request.getParameter("datetimepicker3");
            long ms = formatTime.parse(s_time).getTime();
            Time start = new Time(ms);
            ms = formatTime.parse(e_time).getTime();
            Time end = new Time(ms);

            if (start.after(end)) {
                redirectAttrs.addFlashAttribute("message", "Start time is after end time");
                redirectAttrs.addFlashAttribute("spec", spec_name);
                redirectAttrs.addFlashAttribute("doc", doc_id);
                return "redirect:" + str;
            }
            if (doc_id.equals("")) {
                redirectAttrs.addFlashAttribute("message", "Please select a pediatrician.");
                redirectAttrs.addFlashAttribute("spec", spec_name);
                redirectAttrs.addFlashAttribute("doc", doc_id);
                return "redirect:" + str;
            }

            DatabaseService db = new DatabaseService();
            Object o = db.getEntityById("id", "consultations", Integer.parseInt(vid));
            Consultations visit = (Consultations) o;
            o = db.getEntityById("id", "pediatricians", Integer.parseInt(doc_id));
            Pediatricians ped = (Pediatricians) o;
            visit.setStartTime(start);
            visit.setEndTime(end);
            visit.setVisitDate(date);
            visit.setComments(request.getParameter("comm"));
            visit.setReason(request.getParameter("reason"));
            visit.setPrescription(request.getParameter("pres"));
            visit.setPediatricians(ped);
            db.updateEntity(visit);
        }

        return "redirect:" + str;
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
    
    
    @RequestMapping(value = {"/secret/patient/{pid}/kid/{kid}/visit/delete"}, method = RequestMethod.POST)
    public String deleteVisits(@PathVariable String pid,
            @PathVariable String kid,
            HttpServletRequest request,
            RedirectAttributes redirectAttrs) {
        
        String[] action = request.getParameterValues("action");
        if (action == null) {
            redirectAttrs.addFlashAttribute("message", "Cannot find any action!");
            return "redirect:" + "/secret/patient/" + pid + "/kid/" + kid + "/";
        }
        
        String[] selected_fields = request.getParameterValues("_selected_action");
        if (selected_fields == null) {
            redirectAttrs.addFlashAttribute("message", "Cannot find any select parameters!");
            return "redirect:" + "/secret/patient/" + pid + "/kid/" + kid + "/";
        }

        DatabaseService db = new DatabaseService();
        
        for (String vis : selected_fields){
            Object o = db.getEntityById("id", "consultations", Integer.parseInt(vis));
            db.deleteEntity(o);
        }
        redirectAttrs.addFlashAttribute("info", "Succesfully deleted clinical visits!");
        return "redirect:" + "/secret/patient/" + pid + "/kid/" + kid + "/";
    }
    
    
    @RequestMapping(value = {"/secret/patient/{pid}/kid/{kid}/"}, method = RequestMethod.POST)
    public String updateKid(@PathVariable String pid, 
            @PathVariable String kid, 
            RedirectAttributes redirectAttrs,
            HttpServletRequest request) throws ParseException {
        String _save = request.getParameter("_save");
        String _discard = request.getParameter("_discard");
        if (_discard != null) {
            return "redirect:/secret/patient/" + pid + "/kid/" + kid + "/";
        }
        DatabaseService db = new DatabaseService();
        Object o = db.getEntityById("id", "kids", Integer.parseInt(kid));
        if (o == null) {
            redirectAttrs.addFlashAttribute("message", "Entity selected has not been found!");
            return "redirect:/secret/patient/" + pid + "/kid/" + kid + "/";
        }
        Kids k = (Kids) o;
        
        k.setName(request.getParameter("f_name"));
        
        String str_date = request.getParameter("datetimepicker");

        DateFormat format = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
        Date date = format.parse(str_date);

        k.setBirthDate(date);
        
        db.updateEntity(k);

        redirectAttrs.addFlashAttribute("info", "Succesfully updated children information!");
        return "redirect:/secret/patient/" + pid + "/kid/" + kid + "/";
    }
    
        @RequestMapping(value = {"/secretary/searchpatient"}, 
            method = RequestMethod.POST)
    public String searchForm(HttpServletRequest request, RedirectAttributes attr)
            throws ClassNotFoundException, 
            InstantiationException, IllegalAccessException{
        String table = request.getParameter("table");
        String text = request.getParameter("q_text");
        String cols = request.getParameter("columns");
        ArrayList<String> columns = new ArrayList<>();
        
        String[] result = cols.split(Pattern.quote("|"));
        for (int x=0; x<result.length; x++)
            columns.add(result[x]);
        DatabaseService dbService = new DatabaseService();
        List result_list = dbService.listEntityPartialQuery(table, columns, text);
        String str = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
        
        attr.addFlashAttribute("list", result_list);
        attr.addFlashAttribute("q_text", text);
        
        
        String new_str=str.substring(0, str.lastIndexOf('/')+1);
        return "redirect:" + new_str;
    }

}
