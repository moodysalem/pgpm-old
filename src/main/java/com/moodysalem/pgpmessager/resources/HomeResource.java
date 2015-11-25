package com.moodysalem.pgpmessager.resources;

import com.moodysalem.pgpmessager.hibernate.Entry;
import com.moodysalem.pgpmessager.model.HomeModel;
import com.moodysalem.util.RandomStringUtil;
import org.glassfish.jersey.server.mvc.Viewable;

import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.logging.Level;
import java.util.logging.Logger;

@Path("/")
@Produces(MediaType.TEXT_HTML)
public class HomeResource {


    private static final Logger LOG = Logger.getLogger(HomeResource.class.getName());

    @QueryParam("secret")
    String secret;

    @GET
    public Response showForm() {
        return Response.ok(new Viewable("/templates/Home")).build();
    }

    @Inject
    EntityManager em;

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
                LOG.log(Level.SEVERE, "Failed to create link", e);
                hm.setErrorMessage(ex.getMessage());
            }
        }
        
        return Response.ok(new Viewable("/templates/Home", hm)).build();
    }
}
