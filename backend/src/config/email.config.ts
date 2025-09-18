export const emailConfig = {
  host: process.env.MAIL_HOST || 'smtp.gmail.com',
  port: parseInt(process.env.MAIL_PORT || '587'),
  secure: false, // true pour 465, false pour autres ports
  auth: {
    user: process.env.MAIL_USER,
    pass: process.env.MAIL_PASS,
  },
  defaults: {
    from: `"Edor" <${process.env.MAIL_FROM || 'noreply@edor.com'}>`,
  },
};
