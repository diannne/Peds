/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.awt.Color;
import java.awt.Font;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.security.Principal;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import model.HibernateUtil;
import model.Parents;
import model.UserRoles;
import model.Users;
import nl.captcha.Captcha;
import nl.captcha.backgrounds.GradiatedBackgroundProducer;
import nl.captcha.text.renderer.DefaultWordRenderer;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.HandlerMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;
import org.springframework.web.util.WebUtils;
import service.DatabaseService;

@Controller
public class LoginController {

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public ModelAndView loginForm() {
        return new ModelAndView("loginPage");
    }

    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logoutPage(HttpServletRequest request, HttpServletResponse response) {
        SecurityContext secContext = SecurityContextHolder.getContext();
        Authentication auth = secContext.getAuthentication();

        if (auth != null) {
            SecurityContextLogoutHandler secContextLogout = new SecurityContextLogoutHandler();
            if (secContextLogout != null) {
                //performing logout through security context logout handler...
                secContextLogout.logout(request, response, auth);
            }
        }
        return "redirect:/login?logout";
    }

//    @RequestMapping(value = "/register", method = RequestMethod.GET)
//    public String registrationForm(Model model) {
//        Parents p = new Parents();
//        model.addAttribute("parent", p);
//        return "registration";
//    }
    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public ModelAndView registrationForm(HttpSession httpSession, ModelMap map) throws IOException {
        Parents p = new Parents();
        ModelAndView mv = new ModelAndView("registration");
        mv.addObject("parent", p);

        //create the captcha to be displayed
        Captcha captcha = createCaptcha(120, 50);
        //add captcha to current http session

        httpSession.setAttribute("captcha", captcha);
        //encode the captcha as a string and displayed it as a png image
        String image = base64Conversion(captcha);
        map.addAttribute("captchaimage", image);

        return mv;
    }

    //this method will save a parent and an user to the database
    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public ModelAndView addUserToDb(@Valid @ModelAttribute("parent") Parents p,
            BindingResult result, HttpServletRequest request, RedirectAttributes redirectAttributes) {
        ModelAndView mv = new ModelAndView("registration");
        
        if (result.hasErrors()) {
            return mv;
        }
        String snd_pass = request.getParameter("pass_conf");
        if (!snd_pass.equals(p.getPassword())){
            mv.addObject("message", "The two passwords do not match!");
            //redirectAttributes.addFlashAttribute("message", "The two passwords do not match!");
            return mv;
        }
        
        Captcha good_captcha = (Captcha) WebUtils.getSessionAttribute(request, "captcha");
        String actual = good_captcha.getAnswer();
        String inputted = request.getParameter("j_captcha");
        
        if (!actual.equals(inputted)){
            mv.addObject("message", "Captcha verification failed!");
            //redirectAttributes.addFlashAttribute("message", "Captcha verification failed!");
            return mv;
        }
        DatabaseService dbService = new DatabaseService();
        Users user = createUserFromParent(p);
        dbService.saveEntity(p);
        dbService.saveEntity(user);

        mv.addObject("info", "Succesfully registered yourself!");
        //redirectAttributes.addFlashAttribute("info", "Succesfully registered yourself!");
        return mv;
    }

    private Users createUserFromParent(Parents p) {
        byte enabled = 1;
        Users user = new Users();
        user.setEnabled(enabled);
        user.setPassword(p.getPassword());
        user.setUsername(p.getEmail());
        UserRoles role = new UserRoles();
        Set userRoleses = new HashSet(0);
        role.setRole("ROLE_USER");
        role.setUsers(user);
        userRoleses.add(role);
        user.setUserRoleses(userRoleses);
        return user;
    }

    private Captcha createCaptcha(int i, int i0) {
        List<Color> colors = new ArrayList<>();
        colors.add(Color.black);
        colors.add(Color.red);
        colors.add(Color.GREEN);
        colors.add(Color.MAGENTA);
        List<Font> fonts = new ArrayList<>();
        fonts.add(new Font("Arial", Font.ITALIC, 40));
        fonts.add(new Font("Comic", Font.BOLD, 40));
        Captcha captcha = new Captcha.Builder(i, i0).addText(new DefaultWordRenderer(colors, fonts))
                .addBackground(new GradiatedBackgroundProducer(Color.white, Color.LIGHT_GRAY))
                .gimp()
                .addBorder()
                .build();
        
        return captcha;
    }

    private String base64Conversion(Captcha captcha) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(captcha.getImage(), "png", baos);
        baos.flush();
        byte[] imageInByteArray = baos.toByteArray();
        baos.close();
        return javax.xml.bind.DatatypeConverter.printBase64Binary(imageInByteArray);
    }
}
