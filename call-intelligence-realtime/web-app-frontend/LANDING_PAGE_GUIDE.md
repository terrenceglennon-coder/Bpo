# Landing Page Customization Guide

Welcome! This guide will help you customize your new landing page with your personal information, n8n link, and WordPress articles.

## Quick Start

The landing page is now the default home page of your application. When users visit, they'll see:
- **Hero Section**: Your personal branding and main call-to-actions
- **About Section**: Information about you and your skills
- **Tools Section**: Quick access to Call Analytics, n8n, and other tools
- **Articles Section**: Your latest WordPress articles
- **Footer**: Contact information and social links

## How to Customize

### 1. Update Personal Information

Edit `/src/LandingPage.js` to customize your personal information:

```javascript
// Around line 85-100 (About Section)
<p>
  Welcome! I specialize in business process optimization...
  [Replace with your own description]
</p>
```

### 2. Update Your Skills

Modify the skill tags to reflect your expertise (around line 100-106):

```javascript
<div className="skills">
  <span className="skill-tag">Your Skill 1</span>
  <span className="skill-tag">Your Skill 2</span>
  // Add more skills as needed
</div>
```

### 3. Configure n8n Link

Update the n8n URL to point to your actual n8n instance:

**Location 1 - Hero Section** (around line 50):
```javascript
<button
  className="btn-secondary"
  onClick={() => window.open('https://your-n8n-instance.com', '_blank')}
>
  Open n8n Automation
</button>
```

**Location 2 - Tools Section** (around line 130):
```javascript
<div
  className="tool-card"
  onClick={() => window.open('https://your-n8n-instance.com', '_blank')}
>
```

Replace `https://your-n8n-instance.com` with your actual n8n URL (e.g., `https://n8n.yourdomain.com`).

### 4. Add Your WordPress Articles

#### Option A: Manual Entry (Simple)

Edit the articles array in the constructor (around line 9-26):

```javascript
this.state = {
  articles: [
    {
      id: 1,
      title: 'Your Article Title',
      excerpt: 'A brief description of your article...',
      date: '2024-01-15',
      link: 'https://yourblog.com/article-slug'
    },
    // Add more articles
  ]
};
```

#### Option B: WordPress API Integration (Advanced)

To automatically fetch articles from WordPress:

1. Add axios if not already present:
```bash
npm install axios
```

2. Add this method to the LandingPage component:

```javascript
async componentDidMount() {
  try {
    const response = await fetch('https://your-wordpress-site.com/wp-json/wp/v2/posts?per_page=3');
    const posts = await response.json();

    const articles = posts.map(post => ({
      id: post.id,
      title: post.title.rendered,
      excerpt: post.excerpt.rendered.replace(/<[^>]*>/g, '').substring(0, 150) + '...',
      date: new Date(post.date).toISOString().split('T')[0],
      link: post.link
    }));

    this.setState({ articles });
  } catch (error) {
    console.error('Error fetching WordPress articles:', error);
  }
}
```

3. Replace `https://your-wordpress-site.com` with your WordPress site URL.

### 5. Update Social Links

Update your social media links in the footer (around line 170):

```javascript
<div className="social-links">
  <a href="https://linkedin.com/in/yourprofile" className="social-link">
    <i className="fab fa-linkedin"></i>
  </a>
  <a href="https://github.com/yourusername" className="social-link">
    <i className="fab fa-github"></i>
  </a>
  <a href="https://twitter.com/yourhandle" className="social-link">
    <i className="fab fa-twitter"></i>
  </a>
</div>
```

### 6. Customize Colors and Styling

Edit `/src/LandingPage.css` to change colors, fonts, and other styling:

**Primary Colors:**
```css
/* Change the blue color scheme */
background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
/* Replace with your preferred colors */
```

**Fonts:**
```css
.hero-title {
  font-size: 3rem;
  /* Adjust size, weight, etc. */
}
```

## Navigation

- **Landing Page → Analytics**: Click "Go to Call Analytics" or "Explore Call Analytics"
- **Analytics → Landing Page**: Click the "Back to Home" button in the top-left corner

## Running the Application

From the `web-app-frontend` directory:

```bash
# Install dependencies (if not already done)
npm install

# Start the development server
npm start

# Build for production
npm run build
```

The app will open at `http://localhost:3000`

## File Structure

```
web-app-frontend/
├── src/
│   ├── LandingPage.js      # Landing page component (customize here!)
│   ├── LandingPage.css     # Landing page styles
│   ├── App.js              # Main app with navigation logic
│   └── ...
├── public/
│   └── index.html          # HTML template
└── package.json
```

## Tips

1. **Test Locally**: Always test your changes locally before deploying
2. **Responsive Design**: The landing page is mobile-friendly by default
3. **Images**: You can add images to the `public` folder and reference them in your code
4. **SEO**: Update the meta tags in `/public/index.html` for better SEO

## Need Help?

- **FontAwesome Icons**: Already included! Find more icons at [fontawesome.com](https://fontawesome.com/icons)
- **Bootstrap**: Available for additional components via reactstrap
- **React Documentation**: [reactjs.org](https://reactjs.org)

## Next Steps

1. Update your personal information
2. Add your n8n URL
3. Add your WordPress articles
4. Customize the colors to match your brand
5. Update social media links
6. Test everything
7. Deploy!

Enjoy your new landing page! 🚀
