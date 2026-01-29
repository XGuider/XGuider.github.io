/**
 * Lightweight Tag Cloud Implementation
 * No jQuery dependency
 */
document.addEventListener('DOMContentLoaded', function() {
    const tagCloud = document.getElementById('tag_cloud');
    if (!tagCloud) return;

    const tags = tagCloud.querySelectorAll('a');
    const colors = ['#bbbbee', '#99ccdd', '#77aacc', '#5599bb', '#0085a1'];
    const maxFontSize = 1.8;
    const minFontSize = 0.9;

    // Calculate tag frequency
    const tagCounts = {};
    let maxCount = 0;

    tags.forEach(tag => {
        const count = parseInt(tag.dataset.count || tag.title.match(/\d+/)?.[0] || '1');
        tagCounts[tag.href] = count;
        maxCount = Math.max(maxCount, count);
    });

    // Apply styling
    tags.forEach((tag, index) => {
        const count = tagCounts[tag.href] || 1;
        const fontSize = minFontSize + (maxFontSize - minFontSize) * (count / maxCount);
        const colorIndex = Math.floor(index / (tags.length / colors.length));

        tag.style.fontSize = fontSize + 'em';
        tag.style.color = colors[colorIndex];
        tag.style.textDecoration = 'none';
        tag.style.transition = 'all 0.3s ease';

        // Add hover effect
        tag.addEventListener('mouseenter', function() {
            this.style.transform = 'scale(1.1)';
            this.style.opacity = '0.8';
        });

        tag.addEventListener('mouseleave', function() {
            this.style.transform = 'scale(1)';
            this.style.opacity = '1';
        });
    });
});