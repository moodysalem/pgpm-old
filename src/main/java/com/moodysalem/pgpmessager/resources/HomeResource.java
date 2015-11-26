package com.moodysalem.pgpmessager.resources;

import com.moodysalem.pgpmessager.hibernate.Entry;
import com.moodysalem.pgpmessager.model.HomeModel;
import com.moodysalem.pgpmessager.model.LinkEmailModel;
import com.moodysalem.pgpmessager.model.SendMessageModel;
import com.moodysalem.util.RandomStringUtil;
import freemarker.template.Configuration;
import freemarker.template.TemplateException;
import org.glassfish.jersey.server.mvc.Viewable;

import javax.inject.Inject;
import javax.mail.Address;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import javax.ws.rs.*;
import javax.ws.rs.container.ContainerRequestContext;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.io.IOException;
import java.io.StringWriter;
import java.util.List;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.logging.Level;
import java.util.logging.Logger;

@Path("/")
@Produces(MediaType.TEXT_HTML)
public class HomeResource {


    private static final Logger LOG = Logger.getLogger(HomeResource.class.getName());
    public static final String INVALID_SECRET = "Invalid secret.";
    public static final String FAILED_TO_DELETE_SECRET = "Failed to delete secret";
    private static final Executor EMAIL_THREAD_MANAGER = Executors.newFixedThreadPool(5);

    @Context
    ContainerRequestContext req;

    /**
     * Show the form to create an entry
     */
    @GET
    public Response showForm() {
        return Response.ok(new Viewable("/templates/Home")).build();
    }

    /**
     * This presents a screen to a user to send a message
     */
    @GET
    @Path("send")
    public Response getSendForm(@QueryParam("secret") String secret) {
        HomeModel sendModel = new HomeModel();

        Entry e = getEntry(secret, false);
        if (e == null) {
            sendModel.setErrorMessage(INVALID_SECRET);
            return Response.ok(new Viewable("/templates/Home", sendModel)).build();
        } else {
            sendModel.setEntry(e);
        }

        return Response.ok(new Viewable("/templates/SendMessage", sendModel)).build();
    }

    @POST
    @Path("send")
    public Response sendMessage(@QueryParam("secret") String secret, @FormParam("message") String message) {
        HomeModel sendModel = new HomeModel();

        Entry e = getEntry(secret, false);
        if (e == null) {
            sendModel.setErrorMessage(INVALID_SECRET);
            return Response.ok(new Viewable("/templates/Home", sendModel)).build();
        } else {
            sendModel.setEntry(e);
        }

        if (message == null || message.trim().isEmpty()) {
            sendModel.setErrorMessage("Message is required.");
        } else {
            SendMessageModel sm = new SendMessageModel();
            sm.setEntry(e);
            sm.setMessage(message);
            sm.setRequestUrl(req.getUriInfo().getBaseUri().toString());
            sendEmail(e.getEmail(), "You received a message from a friend", "Message.ftl", sm);
            sendModel.setSuccessMessage("Message sent.");
        }


        return Response.ok(new Viewable("/templates/SendMessage", sendModel)).build();
    }


    /**
     * This just deletes an entry
     */
    @GET
    @Path("delete")
    public Response deleteEntry(@QueryParam("secret") String secret) {
        HomeModel hm = new HomeModel();

        Entry e = getEntry(secret, true);
        if (e != null) {
            EntityTransaction et = em.getTransaction();
            try {
                et.begin();
                em.remove(e);
                et.commit();
                hm.setSuccessMessage("Entry deleted.");
            } catch (Exception ex) {
                et.rollback();
                hm.setErrorMessage(FAILED_TO_DELETE_SECRET);
                LOG.log(Level.SEVERE, "Failed to delete entry", ex);
            }
        } else {
            hm.setErrorMessage(INVALID_SECRET);
        }

        return Response.ok(new Viewable("/templates/Home", hm)).build();
    }

    /**
     * Helper to get an entry from the DB
     */
    private Entry getEntry(String secret, boolean admin) {
        CriteriaBuilder cb = em.getCriteriaBuilder();
        CriteriaQuery<Entry> ec = cb.createQuery(Entry.class);
        Root<Entry> er = ec.from(Entry.class);
        ec.select(er);
        if (admin) {
            ec.where(cb.equal(er.get("adminSecret"), secret));
        } else {
            ec.where(cb.equal(er.get("secret"), secret));
        }
        List<Entry> entries = em.createQuery(ec).getResultList();
        if (entries.size() == 1) {
            return entries.get(0);
        }
        return null;
    }

    @Inject
    EntityManager em;

    /**
     * Create an entry from an email and public key
     */
    @POST
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response doPost(@FormParam("email") String email, @FormParam("publicKey") String publicKey) {
        HomeModel hm = new HomeModel();

        if (email == null || publicKey == null || email.trim().isEmpty() || publicKey.trim().isEmpty()) {
            hm.setErrorMessage("E-mail and public key are both required.");
        } else {
            Entry e = new Entry();
            e.setEmail(email);
            e.setPublicKey(publicKey);
            e.setSecret(RandomStringUtil.randomAlphaNumeric(64));
            e.setAdminSecret(RandomStringUtil.randomAlphaNumeric(64));

            EntityTransaction et = em.getTransaction();
            try {
                et.begin();
                em.persist(e);
                em.flush();
                et.commit();
                hm.setSuccessMessage("Successfully created your link. Check your e-mail.");
            } catch (Exception ex) {
                et.rollback();
                LOG.log(Level.SEVERE, "Failed to create link", e);
                hm.setErrorMessage(ex.getMessage());
            }
            sendEmail(e);
        }

        return Response.ok(new Viewable("/templates/Home", hm)).build();
    }


    @Inject
    Session mailSession;
    public static final String FROM_EMAIL = "moody@pgpm.io";
    public static final String FAILED_TO_SEND_EMAIL_MESSAGE = "Failed to send e-mail message";

    protected void sendEmail(Entry entry) {
        LinkEmailModel lem = new LinkEmailModel();
        lem.setEntry(entry);
        lem.setRequestUrl(req.getUriInfo().getBaseUri().toString());
        sendEmail(entry.getEmail(), "Your PGP messager link has been created", "Link.ftl", lem);
    }

    protected void sendEmail(String to, String subject, String template, Object model) {
        try {
            final MimeMessage m = new MimeMessage(mailSession);
            m.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
            Address fromAddress = new InternetAddress(FROM_EMAIL);
            m.setFrom(fromAddress);
            m.setSubject(subject);
            m.setContent(processTemplate(template, model), "text/html");
            EMAIL_THREAD_MANAGER.execute(()-> {
                LOG.info("Sending e-mail.");
                try {
                    Transport.send(m);
                    LOG.info("E-mail sent.");
                } catch (Exception e) {
                    LOG.log(Level.SEVERE, FAILED_TO_SEND_EMAIL_MESSAGE, e);
                }
            });
        } catch (Exception e) {
            LOG.log(Level.SEVERE, FAILED_TO_SEND_EMAIL_MESSAGE, e);
        }
    }

    @Inject
    private Configuration cfg;

    private String processTemplate(String template, Object model) throws IOException, TemplateException {
        StringWriter sw = new StringWriter();
        cfg.getTemplate(template).process(model, sw);
        return sw.toString();
    }
}
